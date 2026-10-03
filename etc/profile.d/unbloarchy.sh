bootstrap=/usr/share/unbloarchy/default/bash/env-bootstrap
[ -r "$bootstrap" ] || bootstrap=/usr/share/omarchy/default/bash/env-bootstrap
[ ! -r "$bootstrap" ] || . "$bootstrap"
unset bootstrap
