---
name: finding-lost-prompts
description: >
  Find the prompts where AI answers leave the brand out, and read the actual answers
  to see why. Use when the user asks "which prompts are we losing?", "why doesn't
  ChatGPT mention us for X?", "why does Perplexity show us but Gemini not?", or wants
  the evidence behind a visibility number.
---

# Finding lost prompts

Start with `get_active_property`. If `has_answers` is false, give its `next_step` and stop.

## 1. Find the gaps

Call `get_matrix` (`metric`: `visibility`, `sov` or `position`). It is one cell per
prompt and engine, so it shows both the prompt you never win and the engine that is
weak across the board. Branded prompts appear here and are flagged; set them aside
when the question is about non-branded demand.

## 2. Read the answers that missed

- `list_chats` with `show=missed` lists the stored answers that left the brand out,
  newest first. Narrow with `prompt_id`, `target` or `days`.
- `get_chat` with an `id` returns one answer in full: the text, every brand found with
  its rank, every source cited, and the searches the engine ran to get there.
- `compare_prompt_chats` with a `prompt_id` lines up every engine's answer to one prompt:
  who each mentioned, in what order, and what each cited.

## 3. Explain the gap

Look for the pattern across several missed answers, not one:

- Which competitors appear in your place, and at what rank.
- Which sources the engine cited. A page that keeps getting cited without you is a
  source to earn (see `finding-sources-to-earn`).
- Which searches the engine ran. Those are the phrasings your pages need to answer.

## Rules

- Quote n. A prompt with only a few answers per engine has not settled.
- Quote at most a short excerpt from an answer, and link the chat rather than pasting it.
- Answers vary from run to run. One missed answer is noise; a run of them is a gap.
- Do not start new runs to "check again" unless the user asks. Runs spend credits
  (see `running-prompts`).
