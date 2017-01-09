install text editor:
  pkg.installed:
    - name: {{ pillar['editor'] }}

get some node installed:
  pkg.installed:
    - name: nodejs

install n node manager:
  cmd.run:
    - name: sudo npm install -g n
    - require:
      - pkg: nodejs

upgrade node to stable:
  cmd.run:
    - name: sudo n stable
    - require:
      - cmd: install n node manager

get a valid ssh key for RS repos:
  file.recurse:
    - source: salt://host_ssh
    - name: /root/.ssh
    - file_mode: 600
    - makedirs: True

record github keys:
  cmd.run:
    - name: ssh-keyscan github.com >> .ssh/known_hosts
    - cwd: /root/
      
clone starter frontend:
  pkg.installed:
    - name: git
  git.latest:
    - name: git@github.com:weareredshift/rs-react-redux-starter-kit.git
    - rev: dev
    - target: /root/frontend
    - require:
      - file: /root/.ssh

install frontend dependencies:
  npm.bootstrap:
    - name: /root/frontend
    - require:
      - cmd: install n node manager
