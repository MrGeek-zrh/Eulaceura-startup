# Eulaceura-startup
Eulaceura启动脚本
- 启动aarch64版本Eulaceura:[start.sh](./start.sh)
- 启动ricv64版本Eulaceura

```bash
# 对qcow2进行扩容
qemu-img resize Eulaceura.aarch64-22H1-Server_vm.R1.qcow2 50G

# 创建一个存储uefi variable的文件
dd if=/dev/zero of=varstore.img bs=1M count=64
```