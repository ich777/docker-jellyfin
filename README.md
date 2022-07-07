# DEPRECATED - Please use the jellyfin/jellyfin repository instead!
## The container is fully compatible with the official Jellyfin container, just change the repository from ich777/jellyfin to jellyfin/jellyfin

# Jellyfin in Docker optimized for Unraid
Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media. It is an alternative to the proprietary Emby and Plex, to provide media from a dedicated server to end-user devices via multiple apps.

**AMD Hardware transcoding (Please note that you have to be on Unraid 6.9.0beta35 to enable the moduel for AMD):**
- Open up a Terminal from Unraid and type in: 'modprobe amdgpu' (without quotes or you edit your 'go' file to load it on every restart of Unraid - refer to the support thread)
- At 'Device' at the bottom here in the template add '/dev/dri'
- In Jellyfin select the VA-API Transcoder at 'Playback' in the Admin section and enable: 'h264', 'HEVC', 'VC1', 'VP9', 'VP8', at the bottom 'Throttle Transcoding' and click 'Save'.

**Intel Hardware transcoding:**
- Download and install the Intel-GPU-TOP Plugin from the CA App
- At 'Device' at the bottom here in the template add '/dev/dri'
- In Jellyfin select the Intel Quick Sync Transcoder at 'Playback' in the Admin section and enable: 'h264', 'HEVC', 'VC1', 'VP9', 'VP8', at the bottom 'Throttle Transcoding' and click 'Save'.

**Nvidia Hardware transcoding:**
- Download and install the Nvidia-Driver Plugin from the CA App
- Turn on the 'Advanced View' here in the template and at 'Extra Parameters' add: '--runtime=nvidia'.
- At 'Nvidia Visible Devices' at the bottom here in the template add your GPU UUID.
- In Jellyfin select the NVENC Transcoder at 'Playback' in the Admin section and enable: 'h264', 'HEVC', 'VC1', 'VP9', 'VP8' (depending on the capabilities of your card), at the bottom 'Throttle Transcoding' and click 'Save'.

## Run example
```
docker run --name Jellyfin -d \
    -p 8096:8096 8920:8920 \
    --env 'UID=99' \
    --env 'GID=100' \
    --env 'UMASK=0000' \
    --env 'DATA_PERMS=770' \
    --volume /mnt/cache/appdata/jellyfin:/config \
    --volume /mnt/cache/jellyfin-cache:/cache \
    --volume /mnt/user/Movies:/movies \
    --volume /mnt/user/TV:/tv \
    --device='/dev/dri \
	ich777/jellyfin
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!
 
#### Support Thread: https://forums.unraid.net/topic/102787-support-ich777-jellyfin-amdintelnvidia/