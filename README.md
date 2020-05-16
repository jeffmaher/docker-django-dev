# Docker Setup for Django Development

This contains a buildable Dockerfile and Docker Compose configuration that can be used for Django software development.

## `Dockerfile`

This creates a standalone image that has the latest versions of Python, Django, and Git installed into Alpine Linux 

### Building 

To build this, run the below, adding in your own naming/version:

```
docker build . -t <docker namespace>/<docker image name>:<docker image version>
```

### Running a Terminal Session

If we named the image `jeffmaher/django-dev:latest`, we can start a terminal session by running and mapping the default Django port of `8000`:

```
docker run -it --rm -p 8000:8000 jeffmaher/django-dev sh
```

You'll likely want to map a directory from your host or import an existing Django app. Let's say you want to start a new project in the `./code` directory on your host machine. You'd start Docker with this command:

```
docker run -it --rm -v ./code:/workspace -p 8000:8000 jeffmaher/django-dev
```

Then create your new Django project:

```
django-admin startproject <name of new django project>
```

If we have an existing Django project, we'd just map that in. For example, if we have the following tree:

```
./code
|- django-project/
|--- .git/
|--- manage.py
|--- (other django stuff)
|- (other files)
```

We could map this into the `/workspace` directory in the container by running this command:

```
docker run -it --rm -v ./code/django-project:/workspace -p 8000:8000 jeffmaher/django-dev
```

### Running Django

Since the Django application is running in the Docker container, you'll need to allow it to receive connections from the host. You can do this by running it at IP address `0.0.0.0` (assumes default Django port of `8000`) from within the container at the top of your Django project (from terminal example: `/workspace/django-project`):

```
python manage.py runserver 0.0.0.0:8000
```

## `docker-compose.yml`

This sets up the Django dev container along with a PostgreSQL database at hostname `db` and port `5432`. Copying this file into a Django project makes it really easy to get running, and you don't need to install very much on your computer to have a clean/repeatable setup (and not pollute what's installed on your machine).

> TODO Add some text about running a pre-existing Django app with Docker Compose.

By default, it uses my pre-build image `jeffmaher/django-dev`. If you've build your own, you'll need to change `services/web/image` to be the name/version of your own image.

### VS Code Setup

My original intent of this was to configure [VS Code's Remote Development extension pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack). To get setup, do the following after dropping this file into your Django project.

1. Open your project directory in VS Code
1. Open the Command Palette (Mac: CMD+SHIFT+P, Win: CTRL+SHIFT+P)
1. Run `Remote-Containers: Reopen in Container`
1. Choose `docker-compose.yml`
1. Choose `web`

From here, you'll be running inside the Docker image and can access its terminal within VS Code. Run your application as:

```
python manage.py runserver 0.0.0.0:8000
```

Note: you may need to add `.devcontainer` to your `.gitignore` file.

