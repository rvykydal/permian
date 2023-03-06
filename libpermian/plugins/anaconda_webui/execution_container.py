import subprocess
import logging
import os


LOGGER = logging.getLogger(__name__)


class ExecutionContainer():
    """ Handles creation, removal of container image and running commands in it """
    def __init__(self, logfile):
        # Initialization of ExecutionContainer is not thread safe and is expected to be done only once in setup_lock
        self.image_name = 'anaconda-webui'

        img = subprocess.check_output(['podman', 'images', '-q', '-f', f'reference={self.image_name}']).decode()
        if img == '':
            containerfile = os.path.join(os.path.dirname(__file__), 'Containerfile')
            subprocess.check_call(['podman', 'build', '-f', containerfile, '-t', self.image_name], stdout=logfile, stderr=subprocess.STDOUT)

    def _podman_cmd(self, cmd, volume, env, cwd, volume_mode):
        env_params = [ item for key, val in env.items() for item in ('-e', f'{key}={val}') ]
        podman_cmd = ['podman', 'run', '--rm', '-it',
                      '-v', f'{volume}:/root/workdir:{volume_mode}',
                      '-w', cwd] + env_params + [self.image_name] + cmd

        LOGGER.debug('Running: ' + repr(podman_cmd))
        return podman_cmd

    def exec(self, cmd, volume, env={}, cwd='/root/workdir', volume_mode='z', log_error=True):
        # Workaround for https://github.com/containers/podman/issues/15789
        # volume_mode should be 'O' but that doesn't work when workdir is in it
        podman_cmd = self._podman_cmd(cmd, volume, env, cwd, volume_mode)

        proc = subprocess.run(podman_cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

        if proc.returncode != 0 and log_error:
            LOGGER.error(proc.stdout.decode())

        return proc

    def popen(self, cmd, volume, env={}, cwd='/root/workdir', volume_mode='z', stdout=subprocess.PIPE):
        podman_cmd = self._podman_cmd(cmd, volume, env, cwd, volume_mode)
        return subprocess.Popen(podman_cmd, stdout=stdout, stderr=subprocess.STDOUT)

    def remove_image(self):
        subprocess.check_call(['podman', 'rmi', self.image_name])
