-- Add rating column back to wines table if it doesn't exist after the refactor

ALTER TABLE public.wines
ADD COLUMN IF NOT EXISTS rating NUMERIC NULL DEFAULT 0;