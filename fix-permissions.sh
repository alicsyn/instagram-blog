#!/bin/bash
# 修复脚本权限

chmod +x /home/u811056906/projects/instagram-blog/deploy.sh
chmod +x /home/u811056906/projects/instagram-blog/rollback.sh
chmod +x /home/u811056906/projects/instagram-blog/quickstart.sh
chmod +x /home/u811056906/projects/instagram-blog/build.sh

echo "✅ 权限修复完成！"
echo ""
echo "现在可以运行："
echo "  ./quickstart.sh"
echo "  ./deploy.sh"

