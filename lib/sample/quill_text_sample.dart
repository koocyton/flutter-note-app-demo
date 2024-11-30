const quillTextSample = [
  {'insert': 'AI 简·记'},
  {
    'attributes': {'header': 1, 'align': 'center'},
    'insert': '\n'
  },
  {'insert': '\n简记APP, 是一款AI对话功能的云备忘录'},
  {
    'attributes': {'header': 2},
    'insert': '\n'
  },
  {'insert': '简记APP, 开发者是'},
  {
    'attributes': {'color': 'rgba(0, 0, 0, 0.847)'},
    'insert': ' and '
  },
  {
    'attributes': {'link': 'https://koocyton.github.io'},
    'insert': 'koocyton'
  },
  {
    'insert':
        ':\n从多个视图跟踪个人和团体日记（ToDo、Note、Ledger）并及时提醒'
  },
  {
    'attributes': {'list': 'ordered'},
    'insert': '\n'
  },
  {
    'insert':
        '与队友分享您的任务和笔记，并在所有设备上实时查看发生的变化'
  },
  {
    'attributes': {'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '查看您和您的队友每天都在做什么'},
  {
    'attributes': {'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '\n与朋友分摊账单从未如此简单。'},
  {
    'attributes': {'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '开始创建群组并邀请您的朋友加入。'},
  {
    'attributes': {'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '创建 Ledger 类型的 BuJo 以查看费用或余额摘要。'},
  {
    'attributes': {'list': 'bullet'},
    'insert': '\n'
  },
  {
    'insert':
        '\n将一个或多个标签附加到任务、注释或事务上。 稍后您只需使用标签即可跟踪它们.'
  },
  {
    'attributes': {'blockquote': true},
    'insert': '\n'
  },
  {
    'attributes': {'font': 'monospace'},
    'insert': "\nvar BuJo = 'Bullet' + 'Journal'"
  },
  {
    'attributes': {'code-block': true},
    'insert': '\n'
  },
  {'insert': '\n开始在浏览器中跟踪'},
  {
    'attributes': {'indent': 1},
    'insert': '\n'
  },
  {'insert': '停止手机上的计时器'},
  {
    'attributes': {'indent': 1},
    'insert': '\n'
  },
  {'insert': '您的所有时间条目均已同步'},
  {
    'attributes': {'indent': 2},
    'insert': '\n'
  },
  {'insert': '手机应用程序之间'},
  {
    'attributes': {'indent': 2},
    'insert': '\n'
  },
  {'insert': '和网站。'},
  {
    'attributes': {'indent': 3},
    'insert': '\n'
  },
  {'insert': '\n'},
  {'insert': '\n中心对齐'},
  {
    'attributes': {'align': 'center'},
    'insert': '\n'
  },
  {'insert': '右对齐'},
  {
    'attributes': {'align': '右'},
    'insert': '\n'
  },
  {'insert': '对齐对齐'},
  {
    'attributes': {'align': 'justify'},
    'insert': '\n'
  },
  {'insert': '找不到东西吗？ '},
  {
    'attributes': {'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '只需在搜索栏中输入'},
  {
    'attributes': {'indent': 1, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '并轻松查找内容'},
  {
    'attributes': {'indent': 2, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '跨项目或文件夹。'},
  {
    'attributes': {'indent': 2, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '它与您的笔记或任务中的文本匹配。'},
  {
    'attributes': {'indent': 1, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '启用提醒，以便您收到通知'},
  {
    'attributes': {'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': 'email'},
  {
    'attributes': {'indent': 1, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '在你的手机上留言'},
  {
    'attributes': {'indent': 1, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '在网站上弹出'},
  {
    'attributes': {'indent': 1, 'list': 'ordered'},
    'insert': '\n'
  },
  {'insert': '创建一个 BuJo 作为项目或文件夹'},
  {
    'attributes': {'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '组织你的'},
  {
    'attributes': {'indent': 1, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '任务'},
  {
    'attributes': {'indent': 2, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': 'notes'},
  {
    'attributes': {'indent': 2, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '交易'},
  {
    'attributes': {'indent': 2, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': 'under BuJo '},
  {
    'attributes': {'indent': 3, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '在日历中查看它们'},
  {
    'attributes': {'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '或分层视图'},
  {
    'attributes': {'indent': 1, 'list': 'bullet'},
    'insert': '\n'
  },
  {'insert': '这是一份检查清单'},
  {
    'attributes': {'list': 'checked'},
    'insert': '\n'
  },
  {'insert': '这是一份未检查的清单'},
  {
    'attributes': {'list': 'unchecked'},
    'insert': '\n'
  },
  {'insert': 'Font '},
  {
    'attributes': {'font': 'sans-serif'},
    'insert': 'Sans Serif'
  },
  {'insert': ' '},
  {
    'attributes': {'font': 'serif'},
    'insert': 'Serif'
  },
  {'insert': ' '},
  {
    'attributes': {'font': 'monospace'},
    'insert': 'Monospace'
  },
  {'insert': ' Size '},
  {
    'attributes': {'size': 'small'},
    'insert': 'Small'
  },
  {'insert': ' '},
  {
    'attributes': {'size': 'large'},
    'insert': 'Large'
  },
  {'insert': ' '},
  {
    'attributes': {'size': 'huge'},
    'insert': 'Huge'
  },
  {
    'attributes': {'size': '15.0'},
    'insert': 'font size 15'
  },
  {'insert': ' '},
  {
    'attributes': {'size': '35'},
    'insert': 'font size 35'
  },
  {'insert': ' '},
  {
    'attributes': {'size': '20'},
    'insert': 'font size 20'
  },
  {
    'attributes': {'token': 'built_in'},
    'insert': ' diff'
  },
  {
    'attributes': {'token': 'operator'},
    'insert': '-match'
  },
  {
    'attributes': {'token': 'literal'},
    'insert': '-patch'
  },
  // {
  //   'insert': {
  //     'image':
  //         'https://pics3.baidu.com/feed/34fae6cd7b899e51ca8f2095810af73fc9950d63.jpeg'
  //   },
  //   'attributes': {'width': '230', 'style': 'display: block; margin: auto;'}
  // },
  {'insert': '\n'}
];
