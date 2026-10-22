# MBot Ubuntu Server

The new SD card image for the MBot Classic in ROB550. It is Ubuntu Server 24.04 with ROS 2 Jazzy, without a desktop. You connect from your laptop with SSH or VS Code, and you use Foxglove in your browser to see the robot's data.

Your code, the labs and the checkpoints work the same way as before. Only the setup is different.

This repository has two things:

- the link to download the image
- the ROB550 website pages for this image, which you can open on your own computer

## 1. Download the image

[Download from Dropbox](https://www.dropbox.com/scl/fo/2x70dspqzdd3rrxu60g9n/AIrzrIsXB5RSlizuFKRoO2U?rlkey=6zx5hzsry09gxthtzed7afu9s&st=3z4jw5jq&dl=0)

File: `2026-10-22-MBOT-UBUNTU-SERVER_IMAGE.img.xz` (2.4 GB)

To make sure the download is complete, run this in the folder where you saved it:

```bash
shasum -a 256 2026-10-22-MBOT-UBUNTU-SERVER_IMAGE.img.xz
```

(On Windows: `certutil -hashfile 2026-10-22-MBOT-UBUNTU-SERVER_IMAGE.img.xz SHA256`)

It should print `1af1148410ae8aec73227b72c2d04822c77c20ffad5d846ec118bd40ea79dfe8`. If it prints something else, download the file again.

## 2. Set up your robot

The full steps are on the website (section 3 below), under **Botlab > MBot System Setup**. In short:

1. Flash the image to the SD card with [Balena Etcher](https://etcher.balena.io/).
2. On the SD card, open `mbot_config.txt` and set `mbot_hostname`, for example `mbot-AM-team6-johndoe`. Add your home Wi-Fi if you want to use the robot at home.
3. Put the SD card in the robot and turn it on. After about a minute the screen on the robot (the OLED) shows its IP address.
4. Connect from your laptop:

   ```bash
   ssh mbot@<IP address on the OLED>
   ```

   Password: `i<3robots!` (change it with `passwd`)

5. On campus, connect the robot to MWireless:

   ```bash
   sudo mwireless-setup
   ```

6. Check that everything works:

   ```bash
   mbot health
   ```

## 3. Open the course website on your computer

You need [Docker Desktop](https://www.docker.com/products/docker-desktop/) (only to build the site) and python3.

```bash
git clone --recurse-submodules https://github.com/Hems-M/mbot-ubuntu-server.git
cd mbot-ubuntu-server
website/serve.sh
```

The first time takes a few minutes. Then open:

http://localhost:4000/docs/botlab/mbot-system-setup-Pi5.html

Press `Ctrl+C` in the terminal to stop it. Next time, `website/serve.sh` opens it right away.

## Commands on the robot

| Command | What it does |
|---------|--------------|
| `mbot --help` | List of the commands you need, by topic |
| `mbot health` | Checks the robot: network, Pico, battery, LiDAR, camera, temperature, fan, memory, disk |
| `mbot health --live` | The same, updated every second (`Ctrl+C` to quit) |
| `mbot report` | Saves the health check and logs in one file to send to the GSIs |
| `sudo mwireless-setup` | Connects the robot to MWireless |
| `sudo mbot-upload-firmware flash <file>.uf2` | Flashes firmware to the Pico |
| `mbot-help manual` | The full command manual (also `~/MBOT_COMMANDS.md`) |

## Flashing the firmware

**Keep the green/white wire between the Raspberry Pi and the control board unplugged.** If you press the BOOTSEL or RST button while it is plugged in, it can damage the Raspberry Pi.

Flash with the same command as always:

```bash
sudo mbot-upload-firmware flash mbot_classic_ros.uf2
```

If it asks you to, put the Pico in flashing mode with the buttons on the control board: hold **RST** and **BOOTSEL**, let go of **RST** first, then **BOOTSEL**. The command waits for you and then finishes on its own.

## Foxglove

Foxglove replaces RViz and NoMachine. On the robot, in two terminals:

```bash
ros2 launch foxglove_bridge foxglove_bridge_launch.xml
```

```bash
ros2 launch mbot_bringup mbot_bringup.launch.py
```

Then go to [app.foxglove.dev](https://app.foxglove.dev/), choose **Open connection**, **Foxglove WebSocket**, and enter `ws://<robot IP>:8765`. To see the LiDAR, open the settings of the **3D** panel, then **Topics**, and turn on `/scan` and `/robot_description`.

## Need help?

Run `mbot report` on the robot. It tells you how to copy the file to your laptop. Send that file to the GSIs with your question.
