# Build and Deploy a Modern YouTube Clone Application in React JS with Material UI 5

![YouTube](https://i.ibb.co/4R5RkmW/Thumbnail-5.png)

### [🌟 Become a top 1% Next.js 13 developer in only one course](https://jsmastery.pro/next13)
### [🚀 Land your dream programming job in 6 months](https://jsmastery.pro/masterclass)

### Showcase your dev skills with practical experience and land the coding career of your dreams
💻 JS Mastery Pro - https://jsmastery.pro/youtube
✅ A special YOUTUBE discount code is automatically applied!

📙 Get the Ultimate Frontend & Backend Development Roadmaps, a Complete JavaScript Cheatsheet, Portfolio Tips, and more - https://www.jsmastery.pro/links
---

# Build and Test Locally:
```bash
docker build -t youtube-app .
docker run -p 8080:80 youtube-app
```

## Troubleshooting:
1. Resolve the 404 error
Check contianer logs:
`docker logs <CONTAINER ID>`

2. **Health Check Endpoint**
- The React app’s frontend routes all requests (including `/health` and `/ping`) to the same `index.html`, which is typical for single-page applications (SPAs) where client-side routing handles paths.

- **Problem for ALB Health Checks:**
    - The ALB *health check expects a lightweight endpoint that returns a 200 OK status* with minimal payload (e.g., plain text or JSON).
    - The *HTML response is too heavy* and not designed for health checks, potentially slowing down the ALB’s checks and wasting resources.

- **Solution:**    
    - Since App Is Purely Frontend (e.g., React served by Nginx): Add a lightweight health check endpoint via Nginx configuration.
    i.e *configure Nginx to serve a /health endpoint*


---

# Why Nginx
1. I picked nginx because it's lightweight
YouTube Clone app, built with React JS and Material UI 5, is a single-page application (SPA). After running npm run build, the output (build/) consists of static files (HTML, CSS, JS).

2. **Routing for SPAs**: Handles client-side routing (e.g., React Router) by redirecting all paths to index.html.

3. **Load balancing**: Useful for when I scale the app across multiple pods in EKS.

4. **Caching**: Improves performance for static assets.

## Alternative is AWS S3
An alternative to Nginx is to use AWS S3 to host the static build/ directory on S3 with a CloudFront CDN, bypassing EKS

---

## Handling SPA Routing with Nginx
React SPAs often use client-side routing (e.g., React Router). If a user navigates directly to a route like /video/123, the server must return `index.html` to let the React app handle the route. Nginx requires a configuration to support this.

- **Default Behavior**: Without configuration, Nginx returns a 404 for non-root paths (e.g., /video/123).
- **Solution**: Add a custom Nginx configuration

## Confirm Routing Type
app’s code structure, as shown in `src/App.js` and `src/index.js`, confirms it’s a React SPA using React Router for **client-side routing**

The App.js uses **React Router** (`BrowserRouter`) with routes like `/video/:id`, `/channel/:id`, and `/search/:searchTerm`. These are **client-side routes**, meaning the React app handles them in the browser, not the server.

For client-side routing to work, **all non-static requests** (e.g., `/video/123`) must return `index.html`, allowing the React app to load and handle the route via JavaScript.

### Expected Behavior:
User request -> 
Nginx checks if the requested URI exists as a file (e.g., /static/js/main.<hash>.js).
If the file exists (e.g., for static assets), it’s served directly.
If the file doesn’t exist (e.g., /video/123), Nginx serves /index.html instead.
This ensures that all client-side routes (/video/:id, /channel/:id, /search/:searchTerm) return index.html, allowing React Router to handle the routing in the browser.

---

## Docker Image Deployment
- Built a custom Docker image for the application.
- Pushed the image to Docker Hub for public access.
- Configured EKS deployments to pull the image using Kubernetes manifests.