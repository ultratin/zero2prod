-- Add migration script here
ALTER TABLE subscriptions_tokens
    RENAME TO subscription_tokens;