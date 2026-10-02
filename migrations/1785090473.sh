echo "Repair fingerprint support left without a libfprint"

# An earlier version of this migration swapped libfprint-git for stock
# libfprint in two steps. A run that failed between them left fprintd with
# no library; finish with the driver the fingerprint setup installs now.
if unbloarchy-pkg-present fprintd && unbloarchy-pkg-missing libfprint && unbloarchy-pkg-missing libfprint-git; then
  unbloarchy-pkg-add libfprint-git
fi
