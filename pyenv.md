Using pyenv

Another approach to using different Python versions is to use pyenv, a popular Python version management tool. Pyenv allows you to easily install and switch between multiple Python versions on the same machine. Here are the basic steps to use pyenv:

1. Install pyenv by following the instructions in the official pyenv repository: [pyenv](https://github.com/pyenv/pyenv#installation)

2. Install the desired Python versions using pyenv. For example, to install Python 3.9, run the following command:

pyenv install 3.9.0

3. Create a new virtual environment using the desired Python version. For example:

pyenv virtualenv 3.9.0 myenv

4. Activate the virtual environment:

pyenv activate myenv

This will set the desired Python version for the current shell session.

5. Install packages and work on your project within the activated virtual environment.

6. Deactivate the virtual environment when you are done:

pyenv deactivate

Pyenv provides a flexible and convenient way to manage multiple Python versions and virtual environments, making it a popular choice for developers who frequently switch between different Python environments.
