# Estágio 1: Imagem Base
# Usando uma imagem oficial e leve do Python com base no Alpine Linux.
# A versão 3.11 é uma escolha estável e recomendada.
FROM python:3.13.5-alpine3.22

# Estágio 2: Variáveis de Ambiente
# Boas práticas para ambientes de contêiner.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Estágio 3: Diretório de Trabalho
# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Estágio 4: Instalação de Dependências
# Instala dependências de build do Alpine, instala os pacotes Python
# e depois remove as dependências de build para manter a imagem final pequena.
# Copiar o requirements.txt primeiro aproveita o cache do Docker.
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps gcc musl-dev && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

# Estágio 5: Copiar o Código da Aplicação
# Copia o restante do código da aplicação para o diretório de trabalho.
# O .dockerignore garantirá que arquivos desnecessários não sejam copiados.
COPY . .

# Estágio 6: Execução
# Expõe a porta que a aplicação usará.
EXPOSE 8000

# Comando para iniciar a aplicação com Uvicorn.
# O host 0.0.0.0 torna a aplicação acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]