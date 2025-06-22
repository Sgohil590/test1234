# Base image
FROM node:20.19.2-bullseye-slim

# Set working directory
WORKDIR /app

# Copy application source code
COPY . .

# Declare build arguments
REACT_APP_AXIOS_BASE_URL_DEV="https://nodejs.sahil.virals.studio/api"
REACT_APP_AXIOS_BASE_URL_STAG="https://nodejs.sahil.virals.studio/api"
REACT_APP_AUTHFLOW="password"
REACT_APP_ENVIRONMENT="staging"
REACT_APP_SOCKET_ENDPOINT="wss://nodejs.sahil.virals.studio"


# Set them as environment variables so React can use them
ENV REACT_APP_AUTHFLOW=$REACT_APP_AUTHFLOW
ENV REACT_APP_AXIOS_BASE_URL_DEV=$REACT_APP_AXIOS_BASE_URL_DEV
ENV REACT_APP_AXIOS_BASE_URL_STAG=$REACT_APP_AXIOS_BASE_URL_STAG
ENV REACT_APP_ENVIRONMENT=$REACT_APP_ENVIRONMENT
ENV REACT_APP_SOCKET_ENDPOINT=$REACT_APP_SOCKET_ENDPOINT

# Install dependencies
RUN npm install

# Build the React app
RUN npm run build

# Install serve to serve the production build
RUN npm install -g serve

# Expose the port the app will run on
EXPOSE 3000

# Run the app with serve
CMD ["serve", "-s", "build", "-l", "3000"]
