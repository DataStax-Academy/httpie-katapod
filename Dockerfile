FROM gitpod/workspace-full

USER root

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null


RUN apt-get clean
RUN curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
	&& apt-get install nodejs
RUN npm install -g astra-setup netlify-cli axios
RUN curl -Ls "https://dtsx.io/get-astra-cli" | bash >> ./workspace/install.log
      

RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN chmod 777 /usr/lib/node_modules/astra-setup/node_modules/node-jq/bin/jq
RUN chown -R gitpod:gitpod /workspace

RUN git clone https://github.com/stargate/stargate/tree/main/docker-compose/cassandra-4.0
RUN chdir stargate/tree/main/docker-compose/cassandra-4.0
RUN docker compose up -d

USER gitpod
RUN pip3 install httpie-astra==0.1.3

EXPOSE 8888
EXPOSE 8443
EXPOSE 3000