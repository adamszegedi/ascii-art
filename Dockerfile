# 1. Start from the smallest reliable base
FROM quay.io/fedora/fedora-minimal:latest

ARG UID=1000
ARG GID=1000
ARG UNAME="ascii"

# 2. Add community/testing repos and install all tools in one layer
# --no-cache avoids storing the index, saving more space
RUN dnf install -y \
        shadow \
        bash \
        cowsay \
        fortune \
        figlet \
        nyancat \
        asciiquarium \
        sl \
        lolcat && \
    # Create the user and group
    groupadd -g "$GID" "$UNAME" && \
    useradd -u "$UID" -g "$GID" -s /bin/bash "$UNAME"

USER $UNAME
WORKDIR /home/$UNAME

# 3. Use heredoc to create the .bashrc
RUN <<EOF cat >> .bashrc
function greet() {
    echo -e "Welcome to the ASCII Art Party! 🎉"
    echo -e "Here are your installed ASCII art tools:"
    echo -e "  🚆 sl - A steam locomotive that runs across your terminal."
    echo -e "  🐮 cowsay - A cow that says whatever you want."
    echo -e "  🌈 lolcat - Makes text look like it is on rainbow-colored LSD."
    echo -e "  📜 figlet - Creates large text banners from small input."
    echo -e "  🐠 asciiquarium - A colorful aquarium with swimming fish."
    echo -e "  🐱 nyancat - The famous pop-tart cat flying across your screen."
    echo -e "  🍀 fortune - Displays random fortune cookie messages."
    echo -e "Try them out with commands like:"
    echo -e " cowsay 'Hello, World!'"
    echo -e "  fortune | cowsay | lolcat"
    echo -e "  asciiquarium"
    echo -e "  nyancat"
    echo -e "Have fun with your ASCII art! 🎨"
}
greet
export PS1='$: '
EOF

CMD ["/bin/bash"]
