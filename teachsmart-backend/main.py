import os
from fastapi import FastAPI
import openai

app = FastAPI()

openai.api_key = os.getenv("OPENAI_API_KEY")

@app.post("/analyze_feedback")
async def analyze_feedback(feedback: str):
    try:
        response = openai.Completion.create(
            engine="text-davinci-003",  # Or a more suitable model
            prompt=f"Analyze the following student feedback:\n\n{feedback}\n\nProvide constructive criticism and suggestions for improvement.",
            max_tokens=150,
            n=1,
            stop=None,
            temperature=0.7,
        )
        return {"analysis": response.choices[0].text.strip()}
    except Exception as e:
        return {"error": str(e)}
