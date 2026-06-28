# 1. Start from a tiny, glibc-compatible base (~30MB)
FROM debian:bookworm-slim

ARG UID=1000
ARG GID=1000
ARG UNAME="ascii"

# 2. Install tools and clean up the apt cache in ONE layer
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        cowsay \
        fortune-mod \
        figlet \
        nyancat \
        asciiquarium \
        sl \
        lolcat && \
    # Clean up apt package lists to save massive amounts of space
    rm -rf /var/lib/apt/lists/* && \
    # Create the user and group (shadow utils are built-in here)
    groupadd -g "$GID" "$UNAME" && \
    useradd -u "$UID" -g "$GID" -m -s /bin/bash "$UNAME"

USER $UNAME
WORKDIR /home/$UNAME

# 3. Use heredoc to create the .bashrc (Debian paths for fortune/cowsay)
RUN <<EOF cat >> .bashrc
function greet() {
    echo -e "Welcome to the ASCII Art Party! 🎉"
    echo -e "Here are your installed ASCII art tools:"
    echo -e "   🚆 sl - A steam locomotive that runs across your terminal."
    echo -e "   🐮 cowsay - A cow that says whatever you want."
    echo -e "   🌈 lolcat - Makes text look like it is on rainbow-colored LSD."
    echo -e "   📜 figlet - Creates large text banners from small input."
    echo -e "   🐠 asciiquarium - A colorful aquarium with swimming fish."
    echo -e "   🐱 nyancat - The famous pop-tart cat flying across your screen."
    echo -e "   🍀 fortune - Displays random fortune cookie messages."
    echo -e "Try them out with commands like:"
    echo -e "   /usr/games/cowsay 'Hello, World!'"
    echo -e "   /usr/games/fortune | /usr/games/cowsay | lolcat"
    echo -e "   asciiquarium"
    echo -e "   nyancat"
    echo -e "Have fun with your ASCII art! 🎨"
}
greet
export PS1='$: '
# Add games to path since Debian installs cowsay/fortune to /usr/games
export PATH=\$PATH:/usr/games
EOF

CMD ["/bin/bash"]