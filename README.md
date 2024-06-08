# Civil Law Assistant

Civil Law Assistant is a Streamlit application that utilizes the OpenAI API to provide assistance with civil law matters. The application allows users to input questions or requests related to civil law and receive responses from an AI assistant.

## Project Structure

The project includes the following files and directories:

- `openai-assistant-api/`
  - `.streamlit/`
    - `secrets.toml` - File containing your OpenAI API key and Assistant ID.
  - `.gitignore` - Git configuration file to ignore unnecessary files.
  - `app.py` - Main source code of the Streamlit application.
  - `docker-compose.yml` - Docker Compose configuration file.
  - `Dockerfile` - Dockerfile to build the Docker image of the application.
  - `requirements.txt` - List of required Python libraries for the project.

## System Requirements

- Python 3.10
- OpenAI API Key
- Streamlit

## Installation

1. Clone the repository from GitHub:

    ```bash
    git clone https://github.com/dailuong435113/Lawbot-with-Assistant-API.git
    cd Lawbot-with-Assistant-API/openai-assistant-api
    ```

2. Create and activate a virtual environment:

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```

3. Install the required libraries:

    ```bash
    pip install -r requirements.txt
    ```

4. Configure the `secrets.toml` file:

    Create a `secrets.toml` file in the `.streamlit/` directory with the following content:

    ```toml
    [general]
    openai_apikey = "Your OpenAI API KEY"
    assistant_id = "Your Assistant ID"
    ```

5. Run the Streamlit application:

    ```bash
    streamlit run app.py
    ```

## Usage

1. Open a web browser and navigate to the address provided by Streamlit (usually `http://localhost:8501`).
2. Enter your question or request into the text box and press Enter.
3. The application will display a response from the AI assistant.

## Main Source Code (`app.py`)

```python
# Importing required packages
import streamlit as st
import time
from openai import OpenAI

# Set your OpenAI API key and assistant ID here
api_key = st.secrets["general"]["openai_apikey"]
assistant_id = st.secrets["general"]["assistant_id"]

# Set openAi client , assistant ai and assistant ai thread
@st.cache_resource
def load_openai_client_and_assistant():
    client = OpenAI(api_key=api_key)
    my_assistant = client.beta.assistants.retrieve(assistant_id)
    thread = client.beta.threads.create()
    return client, my_assistant, thread

client, my_assistant, assistant_thread = load_openai_client_and_assistant()

# check in loop if assistant ai parse our request
def wait_on_run(run, thread):
    while run.status == "queued" or run.status == "in_progress":
        run = client.beta.threads.runs.retrieve(
            thread_id=thread.id,
            run_id=run.id,
        )
        time.sleep(0.5)
    return run

# initiate assistant ai response
def get_assistant_response(user_input=""):
    message = client.beta.threads.messages.create(
        thread_id=assistant_thread.id,
        role="user",
        content=user_input,
    )
    run = client.beta.threads.runs.create(
        thread_id=assistant_thread.id,
        assistant_id=assistant_id,
    )
    run = wait_on_run(run, assistant_thread)
    messages = client.beta.threads.messages.list(
        thread_id=assistant_thread.id, order="asc", after=message.id
    )
    return messages.data[0].content[0].text.value

if 'user_input' not in st.session_state:
    st.session_state.user_input = ''

def submit():
    st.session_state.user_input = st.session_state.query
    st.session_state.query = ''

st.title("⚖️ Civil Law Assistant ⚖️")

st.text_input("Play with me:", key='query', on_change=submit)

user_input = st.session_state.user_input

st.write("You entered: ", user_input)

if user_input:
    result = get_assistant_response(user_input)
    st.header('Assistant :blue[reply] ⚖️', divider='rainbow')
    st.text(result)
```

## Docker Deployment

To deploy the application using Docker, follow these steps:

1. Build the Docker image:

    ```bash
    docker build -t civil-law-assistant .
    ```

2. Run the Docker container:

    ```bash
    docker run -p 8501:8501 --env-file .env civil-law-assistant
    ```

    Create a `.env` file in the root of your project with the following content:

    ```env
    OPENAI_API_KEY=Your_OpenAI_API_Key
    ASSISTANT_ID=Your_Assistant_ID
    ```

3. Open a web browser and navigate to `http://localhost:8501` to access the application.

## Docker Compose Deployment

You can also deploy the application using Docker Compose:

1. Ensure your `docker-compose.yml` file is properly configured:

    ```yaml
    version: '3.8'

    services:
      civil-law-assistant:
        build: .
        ports:
          - "8501:8501"
        env_file:
          - .env
    ```

2. Run the application using Docker Compose:

    ```bash
    docker-compose up --build
    ```

3. Open a web browser and navigate to `http://localhost:8501` to access the application.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

If you have any questions or encounter any issues, please contact me at [email@example.com].
```

Ensure you replace `"Your_OpenAI_API_Key"` and `"Your_Assistant_ID"` with your actual information in the `.env` file for Docker deployment.
