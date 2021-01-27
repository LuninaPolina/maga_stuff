import threading, random, time, keyboard


class Producer(threading.Thread): #appends random number from 0 to 100 to the end of the buffer

    def __init__(self, name, args):
        super(Producer, self).__init__()
        self.name = name
        self.args = args
        
    def run(self):
        while not self.args.stop_flag:
            self.args.mutex.acquire()
            self.args.output_log += self.name + ' locks mutex\n'
            self.args.output_log += 'Buffer was ' + str(self.args.buffer) + '\n'
            random.seed()
            data = random.randint(0, 100)
            self.args.buffer.append(data)
            self.args.output_log += self.name + ' appends ' + str(data) + '\nBuffer is ' + str(self.args.buffer) + '\n'
            self.args.output_log += self.name + ' unlocks mutex\n---\n'
            self.args.mutex.release()
            time.sleep(2)


class Consumer(threading.Thread): #removes first element from the buffer if not empty

    def __init__(self, name, args):
        super(Consumer, self).__init__()
        self.name = name
        self.args = args
        
    def run(self):
        while not self.args.stop_flag:
            self.args.mutex.acquire()
            self.args.output_log += self.name + ' locks mutex\n'
            if len(self.args.buffer) > 0:
                self.args.output_log += 'Buffer was ' + str(self.args.buffer) + '\n'
                data = self.args.buffer[0]
                self.args.buffer.pop(0)
                self.args.output_log += self.name + ' removes ' + str(data) + '\nBuffer is ' + str(self.args.buffer) + '\n'
                self.args.output_log += self.name + ' unlocks mutex\n---\n'
                self.args.mutex.release()
                time.sleep(2)
            else:
                self.args.output_log += self.name + ' unlocks mutex\n---\n'
                self.args.mutex.release()
                time.sleep(2)


class ProgramArgs:
    
    def __init__(self):
        self.mutex = threading.Lock()
        self.buffer = []
        self.stop_flag = False
        self.output_log = ''

        
class Program:
    
    def __init__(self, p_num, c_num):
        self.args = ProgramArgs()
        self.threads = [Producer('ProducerThread-' + str(i), self.args) for i in range(p_num)] + [Consumer('ConsumerThread-' + str(i), self.args) for i in range(c_num)]

    def launch(self):
        random.shuffle(self.threads)
        for th in self.threads:
           th.start()

    def stop(self):
        self.args.stop_flag = True
        for th in self.threads:
           th.join()
           self.args.output_log += th.name + ' is stopped\n'
           
def demonstration():
    print('Enter producers number and consumers number separated by space. Then hit "Enter"')
    try:
        [p_num, c_num] = [int(x) for x in input().split(' ')]
    except:
        print('Invalid input!')
    p = Program(p_num, c_num)
    p.launch()
    print('...Running...\nPress "s" to stop program.')
    keyboard.wait('s')
    print('...Stopping threads...')
    p.stop()
    print('Press "p" to print program execution log or any other key to quit')
    if keyboard.read_key() == 'p':
        print(p.args.output_log)


if __name__ == '__main__':
    demonstration()