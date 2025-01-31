# FastAPI Stripe Integration Setup

This guide will help you set up a FastAPI backend with Stripe integration and webhook handling.

## Initial Setup

1. **Create and activate a Python virtual environment**

2. **Install required dependencies to run main.py**

---

## Stripe CLI Setup

1. **Install the Stripe CLI **

2. **Log in to Stripe**

3. **Start webhook listening:**
   ```bash
   stripe listen --forward-to localhost:8000/webhook
   ```

---

## Environment Configuration

A .env file is already set up. Replace the placeholders with your Stripe credentials:

```env
STRIPE_SECRET_KEY=your_stripe_secret_key  
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret  
```

- Replace your_stripe_secret_key with your actual Stripe API key.
- Replace your_stripe_webhook_secret with your actual Stripe webhook signing secret.

## Run the Application

**Start the FastAPI server with hot reload:**

```bash
uvicorn main:app --reload
```

## Public Endpoint (Optional)

**To expose your local server to the internet for testing purposes, use ngrok:**

```bash
ngrok http 8000
```
