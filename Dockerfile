# React apps require Node.js to run `npm install` and `npm run build` to create the production-ready static files (HTML, CSS, JS)

# Multi-stage builds (using AS build) allow us to separate the build environment (heavy, with Node.js) from the runtime environment (light, with Nginx), reducing the final image size.

# STAGE 1(build stage)
FROM node:18 AS build

# Sets the working dir inside the container to /youtube_app
WORKDIR /youtube_app

# Copy package.json and package-lock.json (if it exists) into the container working directory
# Copying package*.json first allows Docker to cache the npm install step. If package.json hasn’t changed, Docker reuses the cached layer, speeding up builds
COPY package*.json /youtube_app

# Installs app dependencies
RUN npm install

COPY . /youtube_app

# Compiles the React app into static HTML, CSS, and JS files, optimized for production
# The output (build/) is what we’ll serve to users, not the source code.
RUN npm run build


# # STAGE 2(runtime stage)
# Nginx is a lightweight, high-performance web server ideal for serving static files (like the React app’s build/ output)
FROM nginx:alpine

# Copies the build/ output from the build state into nginx default directory for serving files
COPY --from=build /youtube_app/build /usr/share/nginx/html/

# Add custom Nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposes the container to port 80
# Nginx serves HTTP traffic on port 80 by default.
EXPOSE 80

# Run nginx in the foreground to keep the container alive
CMD ["nginx", "-g", "daemon off;"]