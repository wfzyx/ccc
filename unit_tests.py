# flake8: noqa
import subprocess
import unittest


def try_parsing(code: str) -> bool:
    with open("out/tmp.ccc", "w") as f:
        f.write(code)
    r = subprocess.run(
        ["/bin/bash", "-i", "-c", "cd out && grun ccc unit tmp.ccc | wc -l"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    print(r.stderr)
    return False if int(r.stdout) or r.stderr else True


class GrammarTestCase(unittest.TestCase):
    def test_basic_function(self):
        self.assertTrue(try_parsing("""main: fn(): num = { test := 3; };"""))

    def test_fizzbuzz(self):
        self.assertTrue(try_parsing(open("examples/fizzbuzz.ccc").read()))

    def test_for_loop(self):
        self.assertTrue(try_parsing(open("examples/for_loop.ccc").read()))

    def test_match_expression(self):
        self.assertTrue(try_parsing(open("examples/match.ccc").read()))

    def test_invalid_identifiers(self):
        cases = [
            """this_is_not-a_var := 3;""",
            """3this_is_not_a_var := 3;""",
        ]
        all(self.assertFalse(try_parsing(case)) for case in cases)

    def test_valid_identifiers(self):
        cases = [
            """thisisvar := 3;""",
            """thisIsVar := 3;""",
            """ThisIsVar := 3;""",
            """ThisIsVar3 := 3;""",
            """This3IsVar := 3;""",
            """this_is_a_var := 3;""",
            """_this_is_a_var := 3;""",
        ]
        all(self.assertTrue(case) for case in cases)

if __name__ == "__main__":
    unittest.main()
