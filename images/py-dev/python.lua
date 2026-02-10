return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
          ops = function(_, opts)
              opts.jedi_language_server = {
                  before_init = function(init_params, _)
                      local stat = vim.uv.fs_stat("./pyproject.toml")
                      if stat and stat.type == 'file' then
                          local co = coroutine.running()
                          local stdout = {}
                          local stderr = {}
                          local exit_code = 0
                          local jobid = vim.fn.jobstart({"poetry", "env", "info", "-p"}, {
                              on_stdout = function(_, chunk, _)
                                  table.insert(stdout, table.concat(chunk))
                              end,
                              on_stderr = function(_, chunk, _)
                                  table.insert(stderr, table.concat(chunk))
                              end,
                              on_exit = function(_, code, _)
                                  exit_code = code
                                  coroutine.resume(co)
                              end,
                          })
                          assert(jobid)

                          coroutine.yield()
                          if exit_code > 0 then
                              vim.notify(table.concat(stderr, ''))
                          else
                              init_params.initializationOptions.workspace = {
                                  environmentPath = table.concat(stdout, '') .. '/bin/python',
                              }
                          end
                      end
                  end,
              }
          end,
      },
      {
          "williamboman/mason-lspconfig.nvim",
          opts = function(_, opts)
              table.insert(opts.ensure_installed, "jedi_language_server")
          end,
      }
  }
