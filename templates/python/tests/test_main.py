from main import main


def test_main_prints_expected_greeting(capsys):
    main()
    captured = capsys.readouterr()
    assert captured.out.strip() == "Hello from python!"
