/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mai.ci.commandrecognizer;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Random;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 *
 * @author javierfdr
 */
public class ImageTools {

    private static int HEIGHT = 250;
    private static int WIDTH = 250;

    public static void showSpecImage(float[][] spec, float smax, float smin, int height, int width, float smean, int[][] tonalLines) {

        HEIGHT = height;
        WIDTH = width;
        float threshold = (float)0.5;
        
        final BufferedImage img = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = (Graphics2D) img.getGraphics();
        for (int i = 0; i < WIDTH; i++) {
            for (int j = 0; j < HEIGHT; j++) {
                float c = spec[j][i];
                //if (c<smean) c=smin;
                c = 1 - (float) ((c-smin)/(smax-smin));
                

                g.setColor(new Color(c, c, c));
                g.fillRect(i, j, 1, 1);
            }
            for(int t = 0; t < tonalLines[0].length; t++){
                float c = spec[tonalLines[i][t]][i];
                c = (float) ((c-smin)/(smax-smin));
                
                //if (c<0.6) c=0;
                
                g.setColor(new Color(1, 0, 0, c));
                g.fillRect(i, tonalLines[i][t], 1, 1);
            }
        }

        JFrame frame = new JFrame("Image test");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JPanel panel = new JPanel() {

            @Override
            protected void paintComponent(Graphics g) {
                Graphics2D g2d = (Graphics2D) g;
                g2d.clearRect(0, 0, getWidth(), getHeight());
                g2d.setRenderingHint(
                        RenderingHints.KEY_INTERPOLATION,
                        RenderingHints.VALUE_INTERPOLATION_BILINEAR);
                // Or _BICUBIC
                g2d.scale(2, 2);
                g2d.drawImage(img, 0, 0, this);
            }
        };
        panel.setPreferredSize(new Dimension(WIDTH * 2, HEIGHT * 2));
        frame.getContentPane().add(panel);
        frame.pack();
        frame.setVisible(true);
    }
}
