import java.util.*;
import java.util.concurrent.*;

public class Colmeia {
    
    //Classe Tarefa
    static class Tarefa {
        int id;
        int tempo;
        List<Integer> dependencias;
        boolean concluida;
        
        //Construtor
        public Tarefa(int id, int tempo, List<Integer> dependencias) {
            this.id = id;
            this.tempo = tempo;
            this.dependencias = dependencias;
            this.concluida = false;
        }
        
        public boolean podeSerIniciada(List<Integer> tarefasConcluidas) {
            for (int dependencia : dependencias) {
                //Se na lista de dependencia não estiver a tarefa que depende, não inicia
                if (!tarefasConcluidas.contains(dependencia)) {
                    return false;
                }
            }
            return true;
        }
    }
    
    //Classe Operario (Threads)
    static class Operario implements Runnable {
        int id;
        List<Tarefa> tarefas;
        List<Integer> tarefasConcluidas;
        
        //Construtor
        public Operario(int id, List<Tarefa> tarefas, List<Integer> tarefasConcluidas) {
            this.id = id;
            this.tarefas = tarefas;
            this.tarefasConcluidas = tarefasConcluidas;
        }
        
        public void run() {
            while (true) {
                Tarefa tarefa = null;

                //synchronized pois vou mexer na lista de tarefas
                synchronized (tarefas) {
                    //varre lista de tarefas, procurando uma que pode ser feita
                    for (Tarefa t : tarefas) {
                        if (t.podeSerIniciada(tarefasConcluidas)) {
                            tarefa = t;
                            tarefas.remove(tarefa);
                            break;
                        }
                    }
                }
                //caso exista a executa
                if (tarefa != null) {
                    try {
                        Thread.sleep(tarefa.tempo);
                        //synchronized pois vou mexer na lista de tarefas concluidas
                        synchronized (tarefasConcluidas) {
                            tarefasConcluidas.add(tarefa.id);
                        }
                        System.out.println("tarefa " + tarefa.id + " feita");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } 
                else {
                    break;
                }
            }
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        int numOperarios = sc.nextInt();
        int numTarefas = sc.nextInt();

        List<Tarefa> tarefas = new ArrayList<>();
        List<Integer> tarefasConcluidas = new ArrayList<>(); //index das tarefas concluidas

        for (int i = 0; i < numTarefas; i++) {
            int id = sc.nextInt();
            int tempo = sc.nextInt();
            List<Integer> dependencias = new ArrayList<>();

            try {
                String dp = sc.nextLine();
                String[] dp1 = dp.trim().split(" ");
            
                for(String num : dp1 ){
                    int aux = Integer.parseInt(num);
                    dependencias.add(aux);
                }

            }catch (Exception e){}
            
            tarefas.add(new Tarefa(id, tempo, dependencias));
        }

        ExecutorService executor = Executors.newFixedThreadPool(numOperarios);
        for (int i = 0; i < numOperarios; i++) {
            executor.execute(new Operario(i + 1, tarefas, tarefasConcluidas));
        }

        executor.shutdown();
        sc.close();
    }
}
