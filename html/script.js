// Questo ascolta i messaggi che arrivano dal file client.lua
window.addEventListener('message', function(event) {
    let data = event.data;

    // Se Lua dice di aprire il menu (comando /hud)
    if (data.action === "openMenu") {
        document.getElementById('settings-menu').style.display = 'flex';
    }

    // Se Lua manda l'aggiornamento dei dati (ogni 200ms)
    if (data.action === "updateHUD") {
        
        // 1. Aggiorna Dati Player (Alto a destra)
        document.getElementById('job-text').innerText = data.job;
        document.getElementById('gang-text').innerText = data.gang;
        document.getElementById('id-text').innerText = "ID: " + data.id;

        // 2. Aggiorna Bussola e Strada
        document.getElementById('compass').innerText = data.compass;
        document.getElementById('street').innerText = "| " + data.street;

        // 3. Aggiorna i livelli di Status (Vita, fame, ecc) - Modifica l'altezza CSS
        document.querySelector('#health .status-bg').style.height = data.health + '%';
        document.querySelector('#armor .status-bg').style.height = data.armor + '%';
        document.querySelector('#hunger .status-bg').style.height = data.hunger + '%';
        document.querySelector('#thirst .status-bg').style.height = data.thirst + '%';
        document.querySelector('#stress .status-bg').style.height = data.stress + '%';

        // 4. Gestione Veicolo e Tachimetro
        let speedo = document.getElementById('speedometer');
        if (data.inVehicle) {
            speedo.classList.remove('hidden'); // Mostra il tachimetro
            document.getElementById('speed').innerText = data.speed;
            document.getElementById('fuel-text').innerText = data.fuel + '%';

            // Cintura
            // Cintura
            let belt = document.getElementById('seatbelt');
            if (data.seatbelt) {
                // Se la cintura è allacciata, NASCONDE l'icona completamente
                belt.style.display = 'none'; 
            } else {
                // Se è slacciata, MOSTRA l'icona rossa lampeggiante
                belt.style.display = 'block';
                belt.classList.remove('on'); 
                belt.classList.add('off');
                belt.innerHTML = '<i class="fas fa-user-slash"></i>';
            }
        } else {
            speedo.classList.add('hidden'); // Nasconde se sei a piedi
        }
    }
});

// Funzione richiamata dal bottone nel Menu Impostazioni
function closeMenu() {
    document.getElementById('settings-menu').style.display = 'none';
    
    // Invia un messaggio a Lua per ridare il controllo del mouse al gioco
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Funzione che cambia la forma/riempimento dallo stile del menu
function changeShape() {
    const shape = document.getElementById('shape-select').value;
    const fill = document.getElementById('fill-select').value;
    const items = document.querySelectorAll('.status-item');
    
    items.forEach(item => {
        item.className = `status-item ${shape} ${fill}`;
    });
}