local M = {}

function M:setup()
    -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    -- local workspace_dir = "/Users/knavnav/development/jdtls_data/" .. project_name
    -- local config = {
    --     -- The command that starts the language server See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    --     cmd = {

    --         -- 💀
    --         "java", -- or '/path/to/java21_or_newer/bin/java'
    --         -- depends on if `java` is in your $PATH env variable and if it points to the right version.
    --         "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    --         "-Dosgi.bundles.defaultStartLevel=4",
    --         "-Declipse.product=org.eclipse.jdt.ls.core.product",
    --         "-Dlog.protocol=true",
    --         "-Dlog.level=ALL",
    --         "-Xmx1g",
    --         "--add-modules=ALL-SYSTEM",
    --         "--add-opens",
    --         "java.base/java.util=ALL-UNNAMED",
    --         "--add-opens",
    --         "java.base/java.lang=ALL-UNNAMED",

    --         -- 💀
    --         "-jar",
    --         "/Users/knavnav/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
    --         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    --         -- Must point to the                                                     Change this to
    --         -- eclipse.jdt.ls installation                                           the actual version

    --         -- 💀
    --         "-configuration",
    --         "/Users/knavnav/.local/share/nvim/mason/packages/jdtls/config_mac",
    --         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    --         -- Must point to the                      Change to one of `linux`, `win` or `mac`
    --         -- eclipse.jdt.ls installation            Depending on your system.

    --         -- 💀
    --         -- See `data directory configuration` section in the README
    --         "-data",
    --         workspace_dir,
    --     },

    --     -- 💀
    --     -- This is the default if not provided, you can remove it. Or adjust as needed.
    --     -- One dedicated LSP server & client will be started per unique root_dir
    --     --
    --     -- vim.fs.root requires Neovim 0.10.
    --     -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    --     root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

    --     -- Here you can configure eclipse.jdt.ls specific settings
    --     -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    --     -- for a list of options
    --     settings = {
    --         java = {},
    --     },

    --     -- Language server `initializationOptions`
    --     -- You need to extend the `bundles` with paths to jar files
    --     -- if you want to use additional eclipse.jdt.ls plugins.
    --     --
    --     -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --     --
    --     -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    --     init_options = {
    --         bundles = {},
    --     },
    -- }
    -- require("jdtls").start_or_attach(config)
        local function contains(table, value)
            for _, table_value in ipairs(table) do
                if table_value == value then
                    return true
                end
            end
            return false
        end

        -- helper function for finding a filename in a directory which matches
        -- the specified pattern
        local function find_file(directory, pattern)
            local filename_found = ''
            local pfile = io.popen('ls "' .. directory .. '"')

            if (pfile == nil) then
                return ''
            end

            for filename in pfile:lines() do
                if (string.find(filename, pattern) ~= nil) then
                    filename_found = filename
                    break
                end
            end

            return filename_found
        end

        -- gathers all of the bemol-generated files and adds them to the LSP workspace
        local function bemol()
            local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
            local ws_folders_lsp = {}
            if bemol_dir then
                local file = io.open(bemol_dir .. "/ws_root_folders", "r")
                if file then
                    for line in file:lines() do
                        table.insert(ws_folders_lsp, line)
                    end
                    file:close()
                end

                for _, line in ipairs(ws_folders_lsp) do
                    if not contains(vim.lsp.buf.list_workspace_folders(), line) then
                        vim.lsp.buf.add_workspace_folder(line)
                    end
                end
            end
        end

        

        local jdtls = require "jdtls"
        local jdtls_setup = require "jdtls.setup"

        local home = os.getenv("HOME")
        local root_markers = { ".bemol", }
        local root_dir = jdtls_setup.find_root(root_markers)
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
        local path_to_mason = home .."/.local/share/nvim/mason"
        local path_to_jdtls = path_to_mason .. "/packages/jdtls"
        local os_type = vim.fn.has("macunix") and "mac" or "linux"
        local path_to_config = path_to_jdtls .. "/config_" .. os_type
        local path_to_lombok = path_to_jdtls .. "/lombok.jar"
        -- local path_to_lombok = path_to_mason"/share/jdtls/lombok.jar"
        local path_to_plugins = path_to_jdtls .. "/plugins/"
        -- the eclipse jar is suffixed with a bunch of version nonsense, so we find it by pattern matching
        local path_to_jar = path_to_plugins .. find_file(path_to_plugins, "org.eclipse.equinox.launcher_")

        -- The latest version of jdtls requires at least Java 21. If your project is not upgraded to Java 21+, uncomment this line and point to your JDK/Contents/Home. This will not affect your builds, only vim.
        -- vim.uv.os_setenv("JAVA_HOME",  "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home")


        local config = {
            cmd = {
                -- assumes the java binary is in your PATH and at least java17;
                -- if not, specify the full path to the binary
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                "-javaagent:" .. path_to_lombok,
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",

                "-jar",
                path_to_jar,

                "-configuration",
                path_to_config,

                "-data",
                workspace_dir,
            },

            root_dir = root_dir,

            capabilities = {
                workspace = {
                    configuration = true
                },
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true
                        }
                    }
                }
            },

            settings = {
                java = {
                    references = {
                        includeDecompiledSources = true,
                    },
                    eclipse = {
                        downloadSources = true,
                    },
                    maven = {
                        downloadSources = true,
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                }
            },

            -- run our bemol function when the LSP attaches to the buffer
            on_attach = bemol,
        }

        jdtls.start_or_attach(config)
    end
return M
