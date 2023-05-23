FROM python:3.9

# node.js is used by some Jupyter extensions
RUN apt update
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y graphviz
RUN apt install -y lsb-release

RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main"
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

RUN apt update
RUN apt install -y redis-server redis

# RUN redis-server --daemonize yes

WORKDIR /root/

RUN /usr/local/bin/python -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install -i https://test.pypi.org/simple/ extreme-venue-sdk
RUN rm requirements.txt
RUN pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension enable @jupyterlab/toc

RUN mkdir -p .jupyter/
COPY .jupyter/*.py .jupyter/

ADD /start.sh .
RUN chmod +755 start.sh

EXPOSE 8888 6379

CMD ["./start.sh"]

