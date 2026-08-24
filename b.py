import requests
import json
import argparse
import sys

API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
# IMPORTANT: Never share your real API key or hardcode it in public repositories.
API_KEY = "YOUR_API_KEY_HERE" 

def get_trigger_explanation(input_filename):
    # 1. Read the prompt from the text file
    try:
        with open(input_filename, "r", encoding="utf-8") as f:
            prompt_text = f.read().strip()
    except FileNotFoundError:
        print(f"❌ Error: The file '{input_filename}' was not found.")
        sys.exit(1)
        
    if not prompt_text:
        print(f"❌ Error: '{input_filename}' is empty. Please add a prompt to the file.")
        sys.exit(1)

    # 2. Send the request
    try:
        url = f"{API_URL}?key={API_KEY}"
        headers = {"Content-Type": "application/json"}

        # Inject the dynamically read text here
        data = {
            "contents": [
                {"parts": [{"text": prompt_text}]}
            ]
        }

        response = requests.post(url, headers=headers, data=json.dumps(data))
        response.raise_for_status()  # Raises an error for non-200 responses

        res_data = response.json()

        # Safely extract the text
        text = (
            res_data.get("candidates", [{}])[0]
            .get("content", {})
            .get("parts", [{}])[0]
            .get("text", "No text found")
        )

        # 3. Write to output
        with open("output.md", "w", encoding="utf-8") as f:
            f.write(text)

        print(f"✅ Read prompt from '{input_filename}'")
        print("✅ Response saved to output.md")

    except requests.exceptions.RequestException as e:
        print("❌ Error:", e)
        if e.response is not None:
            print("Response:", e.response.text)

if __name__ == "__main__":
    # Set up the argument parser
    parser = argparse.ArgumentParser(description="Send a text prompt to the Gemini API.")
    parser.add_argument("input_file", help="The name of the text file containing your prompt.")
    
    # Parse the arguments from the command line
    args = parser.parse_args()
    
    # Pass the provided filename to the function
    get_trigger_explanation(args.input_file)
