# Welcome to ChatS2

**ChatS2** is a Chatbot that uses OpenAI's GPT-3 model (davinci-003) as it's base LLM. 

ChatS2 also uses LangChain package which provides integration with Google Search and other APIs, meaning ChatS2 can "access" internet, otherwise ChatGPT, which is trained just until 2021.

We used LangChain Conversational Agent as our base agent and modified a little bit the prompt template to alter some behaviors when the Chatbot uses a tool (Google API). As this is a open-source project we did set a low max_token_output so don't expect large responses.

> Although ChatS2 can consult the internet, it's not always guaranteed it will return with the right info.

----------------------------------------------------------------------------------------------------------------

The application base API was made with Flask and communicates with OpenAI's API.

Frontend was developed in Flutter Web and uses: 
- GetX for Stage Management
- Clean Architeture
- Firebase Firestore NoSQL, Firebase Hosting and Firebase Authentication

----------------------------------------------------------------------------------------------------------------

Above all, this was a project with the purpose of improve our knowledge on this study field.

LangChain documentation: https://langchain.readthedocs.io/en/latest/
App link: https://chatgpt-ed4c7.web.app/ **(SAFARI CURRENTLY NOT SUPPORTED)**
