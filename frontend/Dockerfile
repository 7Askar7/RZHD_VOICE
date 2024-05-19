# Use a lightweight base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the files from ./build/web/ to the working directory
COPY ./build/web/ .

# Expose port 8080
EXPOSE 8080

# Start the Python server
CMD ["python", "-m", "http.server", "8080"]