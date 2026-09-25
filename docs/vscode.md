# Using VS Code with the Course Container

This guide shows how to connect VS Code to the running Chipyard container so you can edit files, browse the Chipyard source, and use a terminal inside the container, all from one window.

Make sure you have completed the installation steps in the repository's main `README.md` first.

> **Remember:** VS Code does not start the container for you. Every time you want to use VS Code with Chipyard, first open Docker Desktop, then start the container with `docker compose run --rm chipyard` (step 3), and only then attach VS Code (step 4).

---

## 1. Install VS Code

Download and install VS Code for your operating system:

[https://code.visualstudio.com/](https://code.visualstudio.com/)

> **Windows users:** Docker Desktop must be using the WSL 2 backend (this is the default). Also install the **WSL** extension (`ms-vscode-remote.remote-wsl`) in VS Code.

---

## 2. Install the Dev Containers Extension

1. Open VS Code.
2. Open the Extensions view (`Ctrl+Shift+X`, or `Cmd+Shift+X` on macOS).
3. Search for **Dev Containers** and install the extension published by Microsoft (`ms-vscode-remote.remote-containers`).

After installation, a green/blue **remote indicator** button appears in the bottom-left corner of the VS Code window.

---

## 3. Start the Course Container

Make sure Docker Desktop is open and running. Then start the container in a terminal as usual, from the root of the course repository (the `ua-chipyard` folder):

```bash
docker compose run --rm chipyard
```

**Leave this terminal open.** The container only exists while this shell is running. If you type `exit` or close the terminal, the container stops and VS Code disconnects.

You can confirm the container is running with (in a different terminal on your computer):

```bash
docker ps
```

You should see a container named something like `ua-chipyard-chipyard-run-71fa75ab6c72`.

---

## 4. Attach VS Code to the Running Container

> The container from step 3 must be running before you do this. If it is not, VS Code will have nothing to attach to.

1. In VS Code, open the Command Palette (`Ctrl+Shift+P`, or `Cmd+Shift+P` on macOS).
2. Run **Dev Containers: Attach to Running Container...**
3. Select the `ua-chipyard-chipyard-run-...` container.

A new VS Code window opens that is connected to the container. The bottom-left corner shows `Container ghcr.io/tosiron/ua-chipyard...`.

The first time you attach, VS Code installs its server inside the container. This can take a minute or two, especially on Apple Silicon Macs.


---

## 5. Open a Folder

In the attached window, choose **File → Open Folder...** and enter:

```text
/workspace
```

Keep your own work in student-work folder so it is persistent. You can also open other folders, for example `/workspace/chipyard` to browse the Chipyard source code.

---

## 6. Use the Terminal (Optional)

> You can use the terminal you started container or use the terminal on VS Code as an alternative to have source code and terminal in the same window.

Open a terminal in the attached window with **Terminal → New Terminal** (`` Ctrl+` ``). This terminal runs **inside the container**.

New VS Code terminals do not run the course startup script, so load the Chipyard environment first:

```bash
cd /workspace/chipyard
source env.sh
```

You can now build and run programs exactly as described in the other guides.

If you need the course scripts (such as `quiz-run`) in a VS Code terminal, also run:

```bash
export PATH="/workspace/course-scripts:$PATH"
```

---

## Where Your Changes Are Saved

The container is started with `--rm`, so it is deleted when it exits. Only the mounted folders are kept:

| Path in the container     | Saved on your computer? | Notes                                   |
| ------------------------- | ----------------------- | --------------------------------------- |
| `/workspace/student-work` | Yes (`student-work/`)   | Put all of your work here               |
| `/workspace/course`       | Read-only               | Instructor files; do not modify         |
| `/workspace/chipyard`     | **No**                  | Changes are lost when the container exits |
| `/tmp`, home directory    | **No**                  | Changes are lost when the container exits |

> **Important:** If you edit files inside `/workspace/chipyard` (for example, Chipyard tests or generator sources), copy them into `/workspace/student-work` before exiting the container, or they will be lost.

---

## Tips

- **Extensions:** Extensions such as C/C++ or Scala (Metals) must be installed in the attached window. VS Code shows an **Install in Container** button for them. Because the container is recreated each time, you may need to reinstall them after restarting the container.
- **Reconnecting:** After restarting the container with `docker compose run --rm chipyard`, it gets a new name. Repeat step 4 to attach to the new one. VS Code remembers recently opened folders under **File → Open Recent**.
- **Editing only:** If you only need to edit files in `student-work/`, you can also open the `student-work/` folder on your computer directly in VS Code without attaching, since it is shared with the container. You still need the container terminal to build and run.
- **Long-running simulations:** Running simulations in the VS Code terminal works the same as in your normal terminal. Closing the VS Code window stops the process running in that terminal.

---

## Troubleshooting

**"Attach to Running Container" does not list the container**
Make sure `docker compose run --rm chipyard` is still running and that `docker ps` shows the container. On Windows, make sure Docker Desktop is running.

**VS Code shows "Cannot connect" or the server install hangs**
Close the attached window and try attaching again. On Apple Silicon Macs, the first attach can be slow because the container runs under emulation.

**`riscv64-unknown-elf-gcc: command not found` in the VS Code terminal**
Run `source /workspace/chipyard/env.sh` in that terminal.

**My changes disappeared after restarting the container**
They were probably made outside `/workspace/student-work`. See [Where Your Changes Are Saved](#where-your-changes-are-saved).
