runhaskell:
	runhaskell -package-conf=cabal-dev/packages-7.4.2.conf/ $(FILE)
test:
	cabal-dev build
	cabal-dev test
ghci:
	cabal-dev ghci
.PHONY: ghci test ghci
