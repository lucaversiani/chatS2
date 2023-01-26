import os

from flask import Flask, request, abort, Response
from flask_cors import CORS, cross_origin
from chatbot import run_agent

os.environ["INTERNAL_API_KEY"] = str(os.getenv('INTERNAL_API_KEY'))

app = Flask(__name__)
CORS(app, support_credentials=True)


@app.route('/chat', methods=['POST'])
@cross_origin()
def main():
    auth: str = request.headers["Authorization"]
    if auth != os.environ["INTERNAL_API_KEY"]:
        abort(Response(f'Invalid Authorization Token. Aborting.', status=401))

    null = None
    data: dict = request.get_json()

    user_input: str = data["input"]
    memory: None or dict = data["memory"]

    try:
        return run_agent(memory=memory, user_input=user_input)
    except Exception as e:
        abort(Response(str(e), status=400))


if __name__ == 'main':
    app.config['JSON_AS_ASCII'] = False
    app.run(debug=False)
