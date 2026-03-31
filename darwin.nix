    { pkgs, self, username,  ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
           pkgs.vim
        ];

			environment.shellAliases = {
				rebuild = "sudo -i darwin-rebuild switch --flake /users/${username}/dotfiles";
			};

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
			nix.enable = false;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

			security.pam.services.sudo_local.touchIdAuth = true;

#      services = {
#        aerospace = {
#          enable = false;
#          settings = pkgs.lib.importTOML ./aerospace/aerospace.toml;
#        };
#      };

      users.users.${username} = {
        name = username;
        home = "/Users/${username}";
      };

			system = {
				primaryUser = username;
				keyboard = {
					#swapLeftCommandAndLeftAlt = true;
					enableKeyMapping = true;
					userKeyMapping = [
						{
							HIDKeyboardModifierMappingSrc = 30064771299;
							HIDKeyboardModifierMappingDst = 30064771296;
						}
						{
							HIDKeyboardModifierMappingSrc = 30064771296;
							HIDKeyboardModifierMappingDst = 30064771299;
						}
					];

				};

				defaults = {
					NSGlobalDomain = {
						AppleShowAllExtensions = true;
						AppleShowAllFiles = true;
					};

					finder = {
						AppleShowAllExtensions = true;
						AppleShowAllFiles = true;
						ShowPathbar = true;
						#_FXShowPosixPathInTitle = true;
					};

					dock = {
						autohide = true;
						magnification = true;
					};
				};
			};

			programs = {
				vim = {
					enable = true;
					plugins = [
						{
							names = [
								"surround"
								"vim-nix"
                "easymotion"
							];
						}
					];
					vimConfig = ''
            syntax enable
            let mapleader = " "
						set tabstop=2
						set shiftwidth=2
						set expandtab
            set rnu
					'';
				};
			};

      homebrew = {
        enable = true;
        casks = [
          #"kindavim"
          "discord"
          "google-chrome"
          "aerospace"
          "raycast"
          "zoom"
          "messenger"
          "microsoft-teams"
          "steam"
          "android-studio"
          "cursor"
          "visual-studio-code"
          "vlc"
        ];
        brews = [
          #"speedtest"
          #"fnm"
          "cocoapods"
        ];
        masApps={
          "Advanced Screen Share" = 1597458111;
        };
        taps = [
          "nikitabobko/tap"
          "teamookla/speedtest"
        ];
        onActivation.cleanup = "zap";
      };
    }
