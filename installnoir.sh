mkdir -p $HOME/.nargo/bin && \
curl -o $HOME/.nargo/bin/nargo-x86_64-unknown-linux-gnu.tar.gz -L https://github.com/noir-lang/noir/releases/download/nightly/nargo-x86_64-unknown-linux-gnu.tar.gz && \
tar -xvf $HOME/.nargo/bin/nargo-x86_64-unknown-linux-gnu.tar.gz -C $HOME/.nargo/bin/ && \
mkdir -p $HOME/.config/noir-lang
cp -r $HOME/.nargo/bin/noir-lang/* "$HOME/.config/noir-lang/"
echo 'export PATH=$PATH:$HOME/.nargo/bin' >> ~/.bashrc && \
source ~/.bashrc
