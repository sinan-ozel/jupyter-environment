FROM python:3.9

# node.js is used by some Jupyter extensions
RUN apt update
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y graphviz

WORKDIR /root/

RUN /usr/local/bin/python -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install -i https://test.pypi.org/simple/ extreme-venue-sdk
RUN rm requirements.txt
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension enable @jupyterlab/toc

RUN mkdir -p .jupyter/
COPY .jupyter/*.py .jupyter/

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--user=root", "--allow-root"]

