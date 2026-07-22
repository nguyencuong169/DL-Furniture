using DLFurniture.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<NewsItem> News { get; set; } = null!;
    public DbSet<NewsCategory> NewsCategories { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure News table
        modelBuilder.Entity<NewsItem>()
            .ToTable("news")
            .HasKey(n => n.Id);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsId)
            .HasColumnName("news_id")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Titles)
            .HasColumnName("title")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Summary)
            .HasColumnName("summary");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Content)
            .HasColumnName("content");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsImage)
            .HasColumnName("news_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsCategoryId)
            .HasColumnName("news_category_id");

        modelBuilder.Entity<NewsItem>()
            .HasOne(n => n.NewsCategory)
            .WithMany(c => c.NewsItems)
            .HasForeignKey(n => n.NewsCategoryId)
            .OnDelete(DeleteBehavior.Restrict);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Tags)
            .HasColumnName("tags")
            .HasMaxLength(2048);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedDate)
            .HasColumnName("updated_date");

        modelBuilder.Entity<NewsCategory>()
            .ToTable("news_categories")
            .HasKey(c => c.Id);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Slug)
            .HasColumnName("slug")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.DisplayOrder)
            .HasColumnName("display_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.IsActive)
            .HasColumnName("is_active")
            .HasDefaultValue(true);

        modelBuilder.Entity<NewsCategory>()
            .HasIndex(c => c.Slug)
            .IsUnique();
    }
}
