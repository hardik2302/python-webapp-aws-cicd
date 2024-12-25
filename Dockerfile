# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file from the src directory of the host to the /app directory inside the container
COPY src/requirements.txt /app

# Install the Python dependencies listed in the requirements.txt file using pip
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY src/ /app/

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run app.py when the container launches
CMD ["python", "app.py"]
