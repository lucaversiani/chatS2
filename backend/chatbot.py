import os
import json

from langchain.agents import Tool, AgentExecutor, ConversationalAgent
from langchain.chains.conversation.memory import ConversationalBufferWindowMemory
from langchain import OpenAI, LLMChain
from langchain.utilities import GoogleSearchAPIWrapper
from langchain.prompts import PromptTemplate

os.environ["OPENAI_API_KEY"] = str(os.getenv('OPENAI_API_KEY'))
os.environ["GOOGLE_CSE_ID"] = str(os.getenv('GOOGLE_CSE_ID'))
os.environ["GOOGLE_API_KEY"] = str(os.getenv('GOOGLE_API_KEY'))

search: GoogleSearchAPIWrapper = GoogleSearchAPIWrapper()

tools: list = [
    Tool(
        name="Google API",
        func=search.run,
        description="useful for when you need to answer questions about current events or the current state of the world."
    ),
]

prefix: str = """Assistant is a large language model trained by ChatS2 team.\n\nAssistant is designed to be able to assist with a wide range of tasks, from answering simple questions to providing in-depth explanations and discussions on a wide range of topics. As a language model, Assistant is able to generate human-like text based on the input it receives, allowing it to engage in natural-sounding conversations and provide responses that are coherent and relevant to the topic at hand.\n\nAssistant is constantly learning and improving, and its capabilities are constantly evolving. It is able to process and understand large amounts of text, and can use this knowledge to provide accurate and informative responses to a wide range of questions. Additionally, Assistant is able to generate its own text based on the input it receives, allowing it to engage in discussions and provide explanations and descriptions on a wide range of topics.\n\nOverall, Assistant is a powerful tool that can help with a wide range of tasks and provide valuable insights and information on a wide range of topics. Whether you need help with a specific question or just want to have a conversation about a particular topic, Assistant is here to assist.\n\nTOOLS:\n------\n\nAssistant has access to the following tools:"""

suffix: str = """Remember that you have a large knowledge about a lot of stuff, prioritize using your base knowledge than using a tool, do it just when STRICTLY necessary. But, in case you actually use a tool to elaborate your response, add the characters "**" at the END of your response. If you don't use any tools to elaborate your response or if you are talking about previous responses that you had to use a tool to elaborate, DO NOT add the characters.\n\nPrevious conversation history:\n{chat_history}\n\nNew input: {input}\n{agent_scratchpad}"""

prompt: PromptTemplate = ConversationalAgent.create_prompt(
    tools,
    prefix=prefix,
    suffix=suffix,
    input_variables=["chat_history", "input", "agent_scratchpad"]
)

llm_chain: LLMChain = LLMChain(llm=OpenAI(
    temperature=0.7), prompt=prompt)

agent: ConversationalAgent = ConversationalAgent(
    llm_chain=llm_chain, tools=tools)


def run_agent(memory, user_input) -> dict:
    if memory is None:
        memory: ConversationalBufferWindowMemory = ConversationalBufferWindowMemory(
            memory_key="chat_history")
    else:
        memory = json.loads(memory)
        null = None
        memory: ConversationalBufferWindowMemory = ConversationalBufferWindowMemory(
            human_prefix=memory["human_prefix"],
            ai_prefix=memory["ai_prefix"],
            buffer=memory["buffer"],
            output_key=memory["output_key"],
            input_key=memory["input_key"],
            memory_key=memory["memory_key"])

    agent_executor: AgentExecutor = AgentExecutor.from_agent_and_tools(
        agent=agent, tools=tools, memory=memory)

    output: str = agent_executor.run(input=f"{user_input}")

    return {"output": output, "memory": memory.json()}
