import os
from typing import Optional, Dict
from fastapi import FastAPI, Request, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from dotenv import load_dotenv
import stripe
import json

load_dotenv()

app = FastAPI(title="Flutter Stripe Backend")

security = HTTPBearer()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

stripe.api_key = os.getenv("STRIPE_SECRET_KEY")
STRIPE_WEBHOOK_SECRET = os.getenv("STRIPE_WEBHOOK_SECRET")

class PaymentIntentRequest(BaseModel):
    amount: int
    currency: str = "usd"
    payment_method_types: list = ["card"]
    customer: str
    payment_method: Optional[str] = None
    metadata: Optional[Dict] = None
    
    
class EphemeralKeyRequest(BaseModel):
    customer_id: str

class StripeError(HTTPException):
    def __init__(self, error: stripe.error.StripeError):
        super().__init__(
            status_code=error.http_status or 400,
            detail=str(error)
        )

async def verify_api_key(credentials: HTTPAuthorizationCredentials = Depends(security)):
    if credentials.credentials != os.getenv("API_KEY"):
        raise HTTPException(
            status_code=401,
            detail="Invalid API key"
        )
    return credentials

class PaymentMethodRequest(BaseModel):
    token: str
    customer_id: str
    
    


@app.post("/create-payment-method")
async def create_payment_method(
    payment_data: PaymentMethodRequest,
    credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
):
    try:
        payment_method = stripe.PaymentMethod.create(
            type="card",
            card={
                "token": payment_data.token,
            }
        )
        
        if payment_data.customer_id:
            stripe.PaymentMethod.attach(
                payment_method.id,
                customer=payment_data.customer_id,
            )
            
        return {"payment_method_id": payment_method.id}
    except stripe.error.StripeError as e:
        raise StripeError(e)
    
    
    
@app.post("/create-payment-intent")
async def create_payment_intent(
    request: PaymentIntentRequest,
    credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
):
    try:
        intent = stripe.PaymentIntent.create(
            amount=request.amount,
            currency=request.currency,
            payment_method_types=request.payment_method_types,
            customer=request.customer,  # Include customer
            payment_method=request.payment_method,  # Include payment method
            metadata=request.metadata
        )
        return {
            "clientSecret": intent.client_secret,
            "id": intent.id
        }
    except stripe.error.StripeError as e:
        raise StripeError(e)

@app.post("/create-ephemeral-key")
async def create_ephemeral_key(
    request: EphemeralKeyRequest,
    credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
):
    try:
        key = stripe.EphemeralKey.create(
            customer=request.customer_id,
            stripe_version=os.getenv("STRIPE_API_VERSION", "2023-10-16")
        )
        return key
    except stripe.error.StripeError as e:
        raise StripeError(e)


class CustomerCreateRequest(BaseModel):
    email: str
    custom_id: str  # Ensure the field name matches the request body

@app.post("/create-customer")
async def create_customer(
    customer_data: CustomerCreateRequest,  # Use Pydantic model
    credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
):
    try:
        customer = stripe.Customer.create(
            email=customer_data.email,
            id=customer_data.custom_id  # Custom ID for the customer
        )
        return {"customer_id": customer.id}
    except stripe.error.StripeError as e:
        raise StripeError(e)
# @app.post("/create-customer")
# async def create_customer(
#     customer_data: dict,  # Add request body parameter
#     credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
# ):
#     try:
#         customer = stripe.Customer.create(
#             email=customer_data.get('email'),
#             id=customer_data.get('custom_id')  # Custom ID for the customer
#         )
#         return {"customer_id": customer.id}
#     except stripe.error.StripeError as e:
#         raise StripeError(e)

@app.post("/webhook")
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig_header = request.headers.get("stripe-signature")
    
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, STRIPE_WEBHOOK_SECRET
        )
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid payload")
    except stripe.error.SignatureVerificationError:
        raise HTTPException(status_code=400, detail="Invalid signature")

    if event["type"] == "payment_intent.succeeded":
        payment_intent = event["data"]["object"]
        print(f"Payment succeeded for PaymentIntent: {payment_intent['id']}")
    
    elif event["type"] == "payment_intent.payment_failed":
        payment_intent = event["data"]["object"]
        error_message = payment_intent["last_payment_error"]["message"] if payment_intent.get("last_payment_error") else None
        print(f"Payment failed for PaymentIntent: {payment_intent['id']}, Error: {error_message}")

    return {"status": "success"}


@app.post("/confirm-payment")
async def confirm_payment(
    payment_data: dict,
    credentials: HTTPAuthorizationCredentials = Depends(verify_api_key)
):
    try:
        payment_intent = stripe.PaymentIntent.retrieve(
            payment_data["payment_intent_id"]
        )
        
        confirmed_payment = stripe.PaymentIntent.confirm(
            payment_data["payment_intent_id"],
            payment_method=payment_data["payment_method_id"]
        )
        
        return {
            "status": confirmed_payment.status,
            "client_secret": confirmed_payment.client_secret
        }
    except stripe.error.StripeError as e:
        raise StripeError(e)


@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        ssl_keyfile="key.pem", 
        ssl_certfile="cert.pem",
        reload=True
    )