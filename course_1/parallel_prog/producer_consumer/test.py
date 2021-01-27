from main import *
import unittest, threading, keyboard, time

def check_output_log(output_log, p_num, c_num):

    def check_consumer(action):
        name = action[0].split(' ')[0]
        if (action[0] == name + ' locks mutex' and
            action[1] == name + ' unlocks mutex'):
                return True
        else:
            el = action[2].split(' ')[-1]
            new_buf = action[3].split('[')[-1][:-1]
            if new_buf == '':
                old_buf =  el
            else:
                old_buf = el + ', ' + new_buf
            if (action[0] == name + ' locks mutex' and
                action[1] == 'Buffer was [' + old_buf + ']' and
                action[2] == name + ' removes ' + el and
                action[3] == 'Buffer is [' + new_buf + ']' and
                action[4] == name + ' unlocks mutex'):
                    return True
        return False

    def check_producer(action):
        name = action[0].split(' ')[0]
        el = action[2].split(' ')[-1]
        old_buf = action[1].split('[')[-1][:-1]
        if old_buf == '':
            new_buf = el
        else:
            new_buf = old_buf + ', ' + el
        if (action[0] == name + ' locks mutex' and
            action[1] == 'Buffer was [' + old_buf + ']' and
            action[2] == name + ' appends ' + el and
            action[3] == 'Buffer is ['  + new_buf + ']'  and
            action[4] == name + ' unlocks mutex'):
                return True
        return False

    def check_stopping(action):
        for i in range(p_num):
            if not 'ProducerThread-' + str(i) + ' is stopped' in action:
                return False
        for i in range(c_num):
            if not 'ConsumerThread-' + str(i) + ' is stopped' in action:
                return False
        return True
        
    actions = output_log.split('---\n')
    checks = []
    for i in range(len(actions) - 1):
        action = actions[i].split('\n')[:-1]
        if 'Producer' in action[0]:
            checks.append(check_producer(action))
        elif 'Consumer' in action[0]:
            checks.append(check_consumer(action))
        else:
            checks.append(False)
    checks.append(check_stopping(actions[-1].split('\n')[:-1]))
    return not False in checks

                        
class ProgramTest(unittest.TestCase):
           
    def test_1(self):
        p = Program(3, 3)
        p.launch()
        time.sleep(2)
        p.stop()
        self.assertEqual(check_output_log(p.args.output_log, 3, 3), True)

    def test_2(self):
        p = Program(2, 0)
        p.launch()
        time.sleep(2)
        p.stop()
        self.assertEqual(check_output_log(p.args.output_log, 2, 0), True)

    def test_3(self):
        p = Program(0, 3)
        p.launch()
        time.sleep(2)
        p.stop()
        self.assertEqual(check_output_log(p.args.output_log, 0, 3), True)

    def test_4(self):
        p = Program(6, 4)
        p.launch()
        time.sleep(2)
        p.stop()
        self.assertEqual(check_output_log(p.args.output_log, 6, 4), True)

    def test_5(self):
        p = Program(2, 5)
        p.launch()
        time.sleep(2)
        p.stop()
        self.assertEqual(check_output_log(p.args.output_log, 2, 5), True)


if __name__ == '__main__':
    unittest.main()
