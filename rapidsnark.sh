# <circuit.zkey> <witness.wtns> <proof.json> <public.json>
if ! -d "./rapidsnark"
then
    git clone https://github.com/iden3/rapidsnark --recurse-submodules
    cd rapidsnark

    # install deps
    sudo apt install build-essential
    sudo apt-get install libgmp-dev
    sudo apt-get install libsodium-dev
    sudo apt-get install nasm
    sudo apt-get install nlohmann-json3-dev

    npm install
    git submodule init
    git submodule update
    npx task createFieldSources
    npx task buildRust
    npx task buildProver
fi


