# Direct Provider Strategy

When OpenRouter's IP rate-limit is the bottleneck, go direct to source providers. Each has independent rate limits -> higher aggregate throughput, no single IP ceiling.

## Confirmed free providers (probe 2026-07-29)
- **Google AI Studio** — free tier confirmed. Models: Gemma 4, Gemini 2.5 Flash. Limit: 5–15 RPM, ~1,500/day. No credit card.
- **Groq** — free tier. Models: Llama 3.3 70B, Mixtral, Gemma. Limit: 30 RPM, 1,000/day. No credit card.
- **Mistral AI** — free API tier. Models: Codestral, Mistral Small/Large/Nemo, Pixtral. Limit: ~1B tokens/month. Phone verification required.
- **HuggingFace Inference API** — free for popular OSS models. `openai/gpt-oss-20b` is Apache 2.0. Rate-limited per model.

## Integration pattern
1. Confirm free model availability with key (don't skip the auth probe).
2. Add provider to Hermes config.yaml provider list.
3. Prepend top free models to `fallback_providers` chain (before Nous/OpenRouter).
4. Update vault note with auth status + exact setup commands.
5. Test with `hermes fallback list` + a live request.