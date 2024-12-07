# Hetzner VPS Auto Wake and Sleep with SSH Detection

This project automates managing a Hetzner VPS server, allowing it to wake up on an SSH or VS Code connection and shut down when idle. It leverages the Hetzner Cloud API, environment variables, and simple bash scripts for efficient server management.

## Features

- **Wake the server** automatically before connecting.
- **Detect SSH inactivity** and shut down the server after idle periods.
- Securely manage sensitive information using `.env`.

---

## Prerequisites

1. A Hetzner Cloud VPS.
2. API token for Hetzner Cloud (with **Read and Write** permissions).
3. Bash shell (default in Linux/WSL2/macOS).
4. SSH configured to connect to the server.

---

## Setup Guide

### 1. Clone the Repository

```bash
git clone git@github.com:cswenor/hetzner-auto-sleep.git
cd hetzner-auto-sleep
```

---

### 2. Configure Environment Variables

1. **Copy the `.env.template` to `.env`:**

   ```bash
   cp .env.template .env
   ```

2. **Edit the `.env` file** with your details:

   ```bash
   nano .env
   ```

   Example `.env`:

   ```
   HETZNER_API_TOKEN="your-hetzner-api-token"
   HETZNER_SERVER_ID="your-server-id"
   HETZNER_CONNECTION_STRING="your-username@your-vps-ip"
   ```

   - `HETZNER_API_TOKEN`: Your Hetzner API token.
   - `HETZNER_SERVER_ID`: The ID of your Hetzner server.
   - `HETZNER_CONNECTION_STRING`: Your SSH connection string (e.g., `user@192.168.1.1`).

---

### 3. Install Dependencies

No external dependencies are required. Ensure `curl` is installed:

```bash
sudo apt-get install curl
```

---

### 4. Make Scripts Executable

Grant execution permissions to the scripts:

```bash
chmod +x power_on.sh power_off.sh wake_server_and_connect.sh
```

---

### 5. Automate Server Shutdown (Optional)

To automatically shut down the server after detecting no active SSH sessions:

1. Edit the server’s crontab:

   ```bash
   crontab -e
   ```

2. Add the following line:

   ```bash
   */5 * * * * /path/to/check_ssh.sh && /path/to/power_off.sh
   ```

   This checks for active SSH sessions every 5 minutes and powers off the server if none are found.

---

## Usage

### 1. Wake the Server and Connect via SSH

Run the `wake_server_and_connect.sh` script:

```bash
./wake_server_and_connect.sh
```

- This script:
  1. Powers on the server using the Hetzner Cloud API.
  2. Waits for the server to boot.
  3. Connects to the server via SSH.

---

### 2. Manually Power On or Off the Server

- **Power On:**
  ```bash
  ./power_on.sh
  ```
- **Power Off:**
  ```bash
  ./power_off.sh
  ```

---

## Security Notes

- The `.env` file contains sensitive information and should never be committed to version control.
- The `.env` file is ignored by Git using the `.gitignore` file.

---

## File Structure

```
.
├── .env                # Environment variables (not included in Git)
├── .env.template       # Template for environment variables
├── README.md           # Documentation
├── power_on.sh         # Script to power on the server
├── power_off.sh        # Script to power off the server
├── wake_server_and_connect.sh # Script to wake the server and connect via SSH
├── check_ssh.sh        # Script to detect active SSH sessions
└── .gitignore          # Ignore sensitive files
```

---

## Contributing

Feel free to fork this repository and submit pull requests for improvements.

---

## License

This project is licensed under the MIT License.

---

This `README.md` ensures that anyone cloning your repository can set up and use the scripts with ease. Let me know if you’d like to tweak or add anything!
