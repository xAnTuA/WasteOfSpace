local PROTOCOL = { name = "MODULAR", version = "1.0.0"}
-- musimy sie jakos odroznic / gdzies zdefiniowac kim jestesmy
--
-- najpierw czekamy na starter kit - cos co kazdy modul posiada / co ma wspulne

-- wspulne:
-- globalne wartosci,
-- 3 komendy, init, protocol i module meta,
-- petla czekania na komende, i przetwarzanie jej,
--
-- requirePackage -- nie potrzebujemy promise, jezeli jest to asynch task, i funckcja zwraca wartosc
--
-- w takim razie liepiej zrobic object packetMenagera, ktory ma swoje kolalne variables, i jest wstanie dostac nowe pakiety z sieci. i udostepnic obiekt i jego funckcje, jezeli pytajacy ma tego samego wlasciciela badz ma uprawnienia


local PackageManager = {}
PackageManager.__Index = PackageManager


function PackageManager.Require(package,version)

	return package
end

-- podajemy jakie pakiety potrzebujemy - dostajemy do nich referencje


-- implementcja funkcjonalnosci
