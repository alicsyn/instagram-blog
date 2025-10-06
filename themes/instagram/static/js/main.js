/**
 * Instagram 风格博客 - 主 JavaScript 文件
 */

// 等待 DOM 加载完成
document.addEventListener('DOMContentLoaded', function() {
  
  // 移动端菜单切换
  initMobileMenu();
  
  // 图片懒加载
  initLazyLoading();
  
  // 平滑滚动
  initSmoothScroll();
  
  // 返回顶部按钮
  initBackToTop();
  
});

/**
 * 移动端菜单初始化
 */
function initMobileMenu() {
  const menuToggle = document.querySelector('.menu-toggle');
  const navMenu = document.querySelector('.nav-menu');
  
  if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', function() {
      navMenu.classList.toggle('active');
      
      // 切换图标
      const icon = this.querySelector('span');
      if (icon) {
        icon.textContent = navMenu.classList.contains('active') ? '✕' : '☰';
      }
    });
    
    // 点击菜单项后关闭菜单
    const menuItems = navMenu.querySelectorAll('a');
    menuItems.forEach(item => {
      item.addEventListener('click', function() {
        navMenu.classList.remove('active');
        const icon = menuToggle.querySelector('span');
        if (icon) {
          icon.textContent = '☰';
        }
      });
    });
  }
}

/**
 * 图片懒加载
 */
function initLazyLoading() {
  const images = document.querySelectorAll('img[data-src]');
  
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
          imageObserver.unobserve(img);
        }
      });
    });
    
    images.forEach(img => imageObserver.observe(img));
  } else {
    // 降级方案：直接加载所有图片
    images.forEach(img => {
      img.src = img.dataset.src;
      img.removeAttribute('data-src');
    });
  }
}

/**
 * 平滑滚动
 */
function initSmoothScroll() {
  const links = document.querySelectorAll('a[href^="#"]');
  
  links.forEach(link => {
    link.addEventListener('click', function(e) {
      const href = this.getAttribute('href');
      
      if (href === '#') return;
      
      const target = document.querySelector(href);
      
      if (target) {
        e.preventDefault();
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

/**
 * 返回顶部按钮
 */
function initBackToTop() {
  // 创建返回顶部按钮
  const backToTop = document.createElement('button');
  backToTop.className = 'back-to-top';
  backToTop.innerHTML = '↑';
  backToTop.setAttribute('aria-label', '返回顶部');
  document.body.appendChild(backToTop);
  
  // 滚动时显示/隐藏按钮
  window.addEventListener('scroll', function() {
    if (window.pageYOffset > 300) {
      backToTop.classList.add('visible');
    } else {
      backToTop.classList.remove('visible');
    }
  });
  
  // 点击返回顶部
  backToTop.addEventListener('click', function() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });
}

/**
 * 格式化日期
 */
function formatDate(dateString) {
  const date = new Date(dateString);
  const now = new Date();
  const diff = now - date;
  
  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);
  
  if (days > 7) {
    return date.toLocaleDateString('zh-CN');
  } else if (days > 0) {
    return `${days} 天前`;
  } else if (hours > 0) {
    return `${hours} 小时前`;
  } else if (minutes > 0) {
    return `${minutes} 分钟前`;
  } else {
    return '刚刚';
  }
}

/**
 * 复制代码块功能
 */
function initCodeCopy() {
  const codeBlocks = document.querySelectorAll('pre code');
  
  codeBlocks.forEach(block => {
    const pre = block.parentElement;
    const button = document.createElement('button');
    button.className = 'code-copy-btn';
    button.textContent = '复制';
    
    pre.style.position = 'relative';
    pre.appendChild(button);
    
    button.addEventListener('click', async function() {
      try {
        await navigator.clipboard.writeText(block.textContent);
        button.textContent = '已复制!';
        setTimeout(() => {
          button.textContent = '复制';
        }, 2000);
      } catch (err) {
        console.error('复制失败:', err);
      }
    });
  });
}

// 页面加载完成后初始化代码复制功能
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initCodeCopy);
} else {
  initCodeCopy();
}

