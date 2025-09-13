# Smaller runtime image; you can swap to devel if you prefer
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Silence MOTD/news for all users
RUN set -eux; \
    # Per-user quiet login for root
    touch /root/.hushlogin; \
    # Disable Canonical motd-news if present
    if [ -f /etc/default/motd-news ]; then sed -i 's/^ENABLED=.*/ENABLED=0/' /etc/default/motd-news; fi; \
    # Disable dynamic MOTD scripts (the “Welcome to Ubuntu…” etc.)
    if [ -d /etc/update-motd.d ]; then chmod -x /etc/update-motd.d/*; fi

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates tzdata libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Your built tree with bin/ and lib/
COPY dist/ /opt/dorado/

# Make dorado and its libs discoverable
ENV PATH=/opt/dorado/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/dorado/lib:$LD_LIBRARY_PATH

# No ENTRYPOINT – so you can pass "dorado" as the command
CMD ["dorado", "--help"]

