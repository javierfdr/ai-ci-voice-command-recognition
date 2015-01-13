/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mai.ci.commandrecognizer;

import java.util.ArrayList;
import org.apache.log4j.Logger;

/**
 *
 * @author magnux
 */
public class MovingDescent {
    static final Logger logger = Logger.getLogger(SpectrogramRecognizer.class.getName());
    
    private final float[][] spectrogram;
    private final int width;
    private final int height;
    
    private int[][] tonalLines;
    int[][] speechMask;
    ArrayList<Float> toneDifs;
            
    public MovingDescent(float[][] spectrogram, int width, int height){
        this.spectrogram = spectrogram;
        this.width = width;
        this.height = height;
        detectTones();
    }

    private void detectTones() {
        int numCentroids = 20;
        int[] centroids = new int[numCentroids];
        for(int i = 0; i < centroids.length; i++){
            centroids[i]= height * (numCentroids-i-1)/numCentroids;
        }
        
        tonalLines = new int[width][centroids.length];
        
        
        for(int i = 0; i < width; i++){
            
            for(int c = 0; c < centroids.length; c++){
                centroids[c] = descend(i, centroids[c]);
                tonalLines[i][c] = centroids[c];
            }        
        }        
    }
    
    private int searchMax(int pos, int centroid){
        int window = 2;
        int newCentroid = centroid;
        float currentMax = spectrogram[centroid][pos];
        int start = Math.max(centroid-window,0);
        int stop = Math.min(centroid+window,height);
        for(int s = start; s < stop; s++){
            if(spectrogram[s][pos] > currentMax){
                newCentroid = s;
            }
        }
        
        return newCentroid;
    }
    
    private int descend(int pos, int centroid){
        int window = 5;
        float delta = 0;
        int start = Math.max(centroid-window,0);
        int stop = Math.min(centroid+window,height);
        for(int s = start; s < stop-1; s++){
            delta += spectrogram[s+1][pos] - spectrogram[s][pos];
        }
        delta /= window*2;
        logger.debug(delta);
        
        int newCentroid = centroid + (int)(delta);
        if(newCentroid < 0) newCentroid = 0;
        if(newCentroid >= height) newCentroid = height -1;
        logger.debug(newCentroid);
        
        
        return newCentroid;
    }

    public int[][] getTonalLines() {
        return tonalLines;
    }
    
    
    
}
