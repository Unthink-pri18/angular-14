FROM node:20-slim AS first

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build:ssr

FROM node:20-slim AS production

RUN npm install -g pm2


# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=first /app/dist /app/dist

# Install only production dependencies
COPY --from=first /app/package*.json ./

# Expose the port that the server will listen on
EXPOSE 4001

# Start the SSR server
CMD ["pm2-runtime", "start", "npm", "--name", "frontend-app", "--", "run", "serve:ssr"]