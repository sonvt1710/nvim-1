vim.cmd('ab ng Neogit')
if vim.o.ft == 'go' then
  vim.cmd('ab gb GoBuild')
  vim.cmd('ab gt GoTest')
  -- vim.cmd('ab gg GoGet')
  vim.cmd('ab gn GoGenerate')
  vim.cmd('ab gd GoDebug')
  vim.cmd('ab dt GoDebug -t')
  vim.cmd('ab ds GoDebug -s')
  vim.cmd('ab ts GoTestSum')
  vim.cmd('ab tc GoCoverage')
  vim.cmd('ab sc GoTestSubCase')
  vim.cmd('ab tf GoTestFunc')
  vim.cmd('ab at GoAddTest')
end

